# ------------------------------------------------------------------------------
# Init

echo "Loading - elastic.zsh"

# ------------------------------------------------------------------------------
# Vault (secrets storage)
# https://github.com/elastic/infra/blob/master/docs/vault/README.md

#export VAULT_ADDR=https://secrets.elastic.co
export VAULT_ADDR=https://secrets.elastic.co:8200

alias vault-login='vault login -method oidc'

# ------------------------------------------------------------------------------
# Kibana and Security Solution (SIEM)

# Initialize Kibana-related env variables and aliases.
# Wrapping aliases in function so they can be updated w/ version.
kibana-init() {
  export KIBANA_VERSION=${1:-main}
  export KIBANA_HOME="$CODE_HOME/$USERNAME/kibana-$KIBANA_VERSION"
  export ES_DATA_HOME="$DEV_HOME/elastic/es-data-$KIBANA_VERSION"
  export PLUGIN_PATH="x-pack/solutions/security/plugins/security_solution"

  # Each kibana folder runs on different ports
  # Bear in mind the ports for Kibana "proxy" and ES "transport"
  declare -A KIBANA_PORTS
  declare -A ES_PORTS
  KIBANA_PORTS[main]=5601
  KIBANA_PORTS[2nd]=5602
  KIBANA_PORTS[3rd]=5603
  KIBANA_PORTS[4th]=5604
  KIBANA_PORTS[5th]=5605
  KIBANA_PORTS[6th]=5606
  KIBANA_PORTS[7th]=5607
  KIBANA_PORTS["9.0"]=5608
  KIBANA_PORTS["9.1"]=5609

  ES_PORTS[main]=9200
  ES_PORTS[2nd]=9201
  ES_PORTS[3rd]=9202
  ES_PORTS[4th]=9203
  ES_PORTS[5th]=9204
  ES_PORTS[6th]=9205
  ES_PORTS[7th]=9206
  ES_PORTS["9.0"]=9207
  ES_PORTS["9.1"]=9208
  KIBANA_DEV_PORT=${KIBANA_PORTS[$KIBANA_VERSION]:-5601}
  KIBANA_PROXY_PORT=$((KIBANA_DEV_PORT + 10))
  ES_DEV_PORT=${ES_PORTS[$KIBANA_VERSION]:-9200}
  ES_TRANSPORT_PORT=$((ES_DEV_PORT + 100))

  # Update nvm
  nvm use

  # Output some useful info
  echo "KIBANA_HOME=${KIBANA_HOME}"
  echo "ES_DATA_HOME=${ES_DATA_HOME}"
  echo "KIBANA_DEV_PORT=${KIBANA_DEV_PORT}"
  echo "KIBANA_PROXY_PORT=${KIBANA_PROXY_PORT}"
  echo "ES_DEV_PORT=${ES_DEV_PORT}"
  echo "ES_TRANSPORT_PORT=${ES_TRANSPORT_PORT}"
  echo "NODE_OPTIONS=${NODE_OPTIONS}"

  # Delete the folder with Elasticsearch database
  alias clean-es-data='echo "Cleaning KIBANA_VERSION=${KIBANA_VERSION}" && rm -rf $ES_DATA_HOME && echo ".. Done!"'

  # Start bootstrap process because something in package.json changed
  alias start-reset='yarn kbn reset'
  alias start-bootstrap='nvm use && NODE_OPTIONS="--max_old_space_size=8192" yarn kbn bootstrap && NODE_OPTIONS="--max_old_space_size=8192" node scripts/build_kibana_platform_plugins'
  # alias b="header 'ONLY BOOTSTRAPPING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-bootstrap"
  alias start-bes="header 'BOOTSTRAPPING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-bootstrap && header 'STARTING ELASTICSEARCH for \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-es"
  alias start-bess="header 'BOOTSTRAPPING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-bootstrap && header 'STARTING ELASTICSEARCH SERVERLESS \"kibana-$KIBANA_VERSION\"  on \"$CURRENT_BRANCH\" branch/version' && start-es-serverless"

  # Start Elasticsearch
  alias start-es='yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=${ES_DATA_HOME} -E http.port=${ES_DEV_PORT} -E transport.port=${ES_TRANSPORT_PORT}'
  alias start-es-basic='yarn es snapshot --license basic -E xpack.security.authc.api_key.enabled=true -E path.data=${ES_DATA_HOME} -E http.port=${ES_DEV_PORT} -E transport.port=${ES_TRANSPORT_PORT}'
  alias start-es-no-expensive-queries='yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=${ES_DATA_HOME} -E search.allow_expensive_queries=false -E logger.org.elasticsearch.discovery=DEBUG'
  alias start-es-serverless='yarn es serverless --projectType security'

  # Start Kibana
  alias start-kibana='yarn start --server.basePath="/kbn" --elasticsearch.hosts="http://localhost:${ES_DEV_PORT}" --server.port=${KIBANA_DEV_PORT} --dev.basePathProxyTarget=${KIBANA_PROXY_PORT}'
  alias start-kibana-serverless='yarn serverless-security'
  alias debug-kibana='yarn debug --elasticsearch.hosts="http://localhost:${ES_DEV_PORT}" --server.port=${KIBANA_DEV_PORT} --server.basePath="/kbn" --dev.basePathProxyTarget=${KIBANA_PROXY_PORT}'
  alias debug-break-kibana='yarn debug-break --elasticsearch.hosts="http://localhost:${ES_DEV_PORT}" --server.port=5601 --server.basePath="/kbn" --dev.basePathProxyTarget=${KIBANA_PROXY_PORT}'

  alias fe="header 'STARTING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-kibana"
  alias fes="header 'STARTING SERVERLESS \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-kibana-serverless"
  alias fed="header 'DEBUGGING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && debug-kibana"

  # Generate fake source events from Endpoint Security to be able to quickly generate detection alerts
  alias seed-endpoint-data='cd ./x-pack/solutions/security/plugins/security_solution && yarn test:generate --node http://elastic:changeme@127.0.0.1:${ES_DEV_PORT} --kibana http://elastic:changeme@0.0.0.0:${KIBANA_DEV_PORT}/kbn --numHosts=5 --numDocs=2 && popd'
  alias seed-endpoint-data-serverless='cd ./x-pack/solutions/security/plugins/security_solution && yarn test:generate:serverless-dev --numHosts=5 --numDocs=2 && popd'

  # Check the code for type errors using TypeScript
  alias start-type-check='node scripts/type_check.js --project tsconfig.json ${PLUGIN_PATH}'
  alias start-type-check-alerting='node scripts/type_check.js --project x-pack/platform/plugins/shared/alerting/tsconfig.json'

  # Lint with types
  alias start-lint-with-types='node scripts/eslint_with_types --fix --project ${PLUGIN_PATH}/tsconfig.json'
  alias start-lint-with-types-alerting='node scripts/eslint_with_types --fix --project x-pack/platform/plugins/shared/alerting/tsconfig.json'

  # Check the code for linting errors using ESLint
  alias start-lint='node scripts/eslint.js ${PLUGIN_PATH}'
  alias start-lint-all='node scripts/eslint.js'

  # Check the code for i18n issues
  alias start-i18n-check='node scripts/i18n_check --ignore-missing'
  alias start-i18n-fix='node scripts/i18n_check.js --fix'

  # Check the code for circular dependencies
  # Add --debug for showing circular dependencies that were whitelisted
  alias start-deps-check='node scripts/find_plugins_with_circular_deps'

  # Regenerate types based on OpenAPI schema definitions
  alias start-regenerate-openapi='node scripts/generate_openapi --rootDir ./x-pack/solutions/security/plugins/security_solution'

  # Regenerate moon yml
  alias start-regenerate-moon='node scripts/regenerate_moon_projects.js --update'

 # Work with unit tests (Jest)
  alias ut='f() { TESTS_PATH=${1:-""}; node x-pack/scripts/jest.js $TESTS_PATH -o; };f'
  # Run a single file with unit tests in watch mode: test-tdd x-pack/solutions/security/plugins/security_solution/path/to/my/file.test.ts
  alias test-tdd='f() { TESTS_PATH=${1:-""}; node x-pack/scripts/jest.js $TESTS_PATH --watch -o; };f'
  alias debug-tdd='f() { TESTS_PATH=${1:-""}; node --inspect-brk x-pack/scripts/jest.js --runInBand $TESTS_PATH --watch -o; };f'
  alias test-tdd-alerting='test-tdd x-pack/platform/plugins/shared/alerting/'

  alias test-integration-lists='node ./x-pack/scripts/functional_tests --config ./x-pack/test/lists_api_integration/security_and_spaces/config.ts'
  alias test-integration-server-lists='node ./x-pack/scripts/functional_tests_server --config ./x-pack/test/lists_api_integration/security_and_spaces/config.ts'
  alias test-integration-runner-lists='node ./x-pack/scripts/functional_test_runner --config ./x-pack/test/lists_api_integration/security_and_spaces/config.ts'

  # Work with E2E tests (Cypress)
  alias test-cypress-ess='cd ./x-pack/test/security_solution_cypress && yarn cypress:open:ess && popd'
  alias test-cypress-serverless='cd ./x-pack/test/security_solution_cypress && yarn cypress:open:serverless && popd'

  # Backport a PR merged to the "main" branch
  alias start-backport='echo "calling node scripts/backport --pr.. (please pass in PR number)" && node scripts/backport --pr'

  # A few commands for bash to aid in your code searches.
  # Paste the result of ownerpaths into your vscode "files to include" field to search all files we own.
  alias codeowners='cat .github/CODEOWNERS | grep "security-solution\|security-detections-response\|security-detection-rule-management" | cut -d" " -f1 | sed "s@^/@@" | uniq'
  alias ownerpaths='codeowners | paste -sd "," -'

  #FTS debuggging
  alias fts='node x-pack/scripts/functional_tests_server'
  alias ftr='node x-pack/scripts/functional_test_runner'
  # https://nodejs.org/en/learn/getting-started/debugging
  alias fts_debug='node --inspect-wait x-pack/scripts/functional_tests_server'
  alias ftr_debug='node --inspect-wait x-pack/scripts/functional_test_runner'

  # Work with API integration tests (FTR)
  #
  # Start test server:
  #   node x-pack/scripts/functional_tests_server --config x-pack/test/security_solution_api_integration/test_suites/path/to/config.ts
  # Start test runner for a particular test file:
  #   node x-pack/scripts/functional_test_runner --config x-pack/test/security_solution_api_integration/test_suites/path/to/config.ts --include x-pack/test/security_solution_api_integration/test_suites/path/to/test.ts
  #
  # Debug mode for the test server:
  #   node --inspect-brk x-pack/scripts/functional_tests_server --config x-pack/test/security_solution_api_integration/test_suites/path/to/config.ts

  # node x-pack/scripts/functional_tests_server --config x-pack/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/management/trial_license_complete_tier/configs/ess.config.ts
  # node x-pack/scripts/functional_test_runner --config x-pack/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/management/trial_license_complete_tier/configs/ess.config.ts --include x-pack/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/management/trial_license_complete_tier/bootstrap_prebuilt_rules.ts

  alias fts1='node x-pack/scripts/functional_tests_server --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/rule_read/trial_license_complete_tier/configs/ess.config.ts'
  alias ftr1='node scripts/functional_test_runner --bail --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/rule_read/trial_license_complete_tier/configs/ess.config.ts'

  alias fts27='node x-pack/scripts/functional_tests_server --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/rule_creation/trial_license_complete_tier/configs/ess.config.ts'
  alias ftr27='node scripts/functional_test_runner --bail --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/rule_creation/trial_license_complete_tier/configs/ess.config.ts'

  alias fts87='node x-pack/scripts/functional_tests_server --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/rule_management/basic_license_essentials_tier/configs/ess.config.ts'
  alias ftr87='node scripts/functional_test_runner --bail --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/rule_management/basic_license_essentials_tier/configs/ess.config.ts'

  alias fts105='node x-pack/scripts/functional_tests_server --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/common/configs/ess_basic_license.config.ts'
  alias ftr105='node scripts/functional_test_runner --bail --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/common/configs/ess_basic_license.config.ts'

  # Extra stuff
  alias pr-files-by-owner='f() { (cd ${CODE_HOME}/elastic/kibana-operations/triage && node ./code-owners.js "$@"); unset -f f; }; f'
  alias precommit='node scripts/precommit_hook.js'
  alias quick-checks='yarn quick-checks'

  alias change-history-to-main='PTH=x-pack/platform/packages/shared/kbn-change-history && rm -rf "../kibana-main/$PTH" && cp -r "./$PTH" "../kibana-main/$PTH"'
  alias change-history-to-2nd='PTH=x-pack/platform/packages/shared/kbn-change-history && rm -rf "../kibana-2nd/$PTH" && cp -r "./$PTH" "../kibana-2nd/$PTH"'
  alias change-history-to-3rd='PTH=x-pack/platform/packages/shared/kbn-change-history && rm -rf "../kibana-3rd/$PTH" && cp -r "./$PTH" "../kibana-3rd/$PTH"'

  alias alerting-to-main='PTH=x-pack/platform/plugins/shared/alerting/server && rm -rf "../kibana-main/$PTH" && cp -r "./$PTH" "../kibana-main/$PTH"'
  alias alerting-to-2nd='PTH=x-pack/platform/plugins/shared/alerting/server && rm -rf "../kibana-2nd/$PTH" && cp -r "./$PTH" "../kibana-2nd/$PTH"'
  alias alerting-to-3rd='PTH=x-pack/platform/plugins/shared/alerting/server && rm -rf "../kibana-3rd/$PTH" && cp -r "./$PTH" "../kibana-3rd/$PTH"'
}

# Looks at name of current directory ($PWD) and replaces `kibana-` with empty string.
# - If you are in `/home/user/kibana-main` it will run `kibana-init main`
# - If you are in `/home/user/kibana-2nd` it will run `kibana-init 2nd`
kbn() {
  PWD_DIR="${PWD##*/}"
  echo "kibana-init ${PWD_DIR/kibana-/}"
  kibana-init "${PWD_DIR/kibana-/}"
}

kbn
