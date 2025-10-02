# ------------------------------------------------------------------------------
# Vault (secrets storage)
# https://github.com/elastic/infra/blob/master/docs/vault/README.md

echo "Loading - elastic.zsh"

#export VAULT_ADDR=https://secrets.elastic.co
export VAULT_ADDR=https://secrets.elastic.co:8200

# ------------------------------------------------------------------------------
# Kibana and Security Solution (SIEM)

# Initialize Kibana-related env variables and aliases.
# Wrapping aliases in function so they can be updated w/ version.
kibana-init() {
  export KIBANA_VERSION=${1:-main}
  export KIBANA_HOME="$CODE_HOME/sdesalas/kibana-$KIBANA_VERSION"
  export ES_DATA_HOME="$DEV_HOME/elastic/es-data-$KIBANA_VERSION"
  export PLUGIN_PATH="x-pack/solutions/security/plugins/security_solution"

  # Delete the folder with Elasticsearch database
  alias clean-es-data='rm -rf $ES_DATA_HOME'

  # Start bootstrap process because something in package.json changed
  alias start-bootstrap='cd ${KIBANA_HOME} && yarn kbn bootstrap && node scripts/build_kibana_platform_plugins'
  # alias b="header 'ONLY BOOTSTRAPPING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-bootstrap"
  # alias be="header 'BOOTSTRAPPING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-bootstrap && header 'STARTING ELASTICSEARCH for \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-es"
  # alias bes="header 'BOOTSTRAPPING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-bootstrap && header 'STARTING ELASTICSEARCH SERVERLESS \"kibana-$KIBANA_VERSION\"  on \"$CURRENT_BRANCH\" branch/version' && start-es-serverless"


  # Start Elasticsearch
  alias start-es='cd ${KIBANA_HOME} && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=${ES_DATA_HOME}'
  alias start-es-serverless='cd ${KIBANA_HOME} && yarn es serverless --projectType security'

  # Start Kibana
  alias start-kibana='cd ${KIBANA_HOME} && yarn start --server.basePath="/kbn"'
  alias start-kibana-serverless='cd ${KIBANA_HOME} && yarn serverless-security'
  alias debug-kibana='cd ${KIBANA_HOME} && yarn debug  --elasticsearch.hosts="http://localhost:${DEV_ES_HTTP_PORT}" --server.port=${DEV_KIBANA_HTTP_PORT} --server.basePath="/kbn" --dev.basePathProxyTarget=${DEV_KIBANA_BASE_PATH_PROXY_TARGET_PORT}'
  alias debug-break-kibana='cd ${KIBANA_HOME} && yarn debug-break  --elasticsearch.hosts="http://localhost:${DEV_ES_HTTP_PORT}" --server.port=${DEV_KIBANA_HTTP_PORT} --server.basePath="/kbn" --dev.basePathProxyTarget=${DEV_KIBANA_BASE_PATH_PROXY_TARGET_PORT}'

  alias fe="header 'STARTING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-kibana"
  alias fes="header 'STARTING SERVERLESS \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-kibana-serverless"
  alias fed="header 'DEBUGGING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && debug-kibana"

  # Generate fake source events from Endpoint Security to be able to quickly generate detection alerts
  alias seed-endpoint-data='cd ${KIBANA_HOME}/x-pack/solutions/security/plugins/security_solution && yarn test:generate --node http://elastic:changeme@127.0.0.1:9200 --kibana http://elastic:changeme@0.0.0.0:5601/kbn --numHosts=5 --numDocs=2'
  alias seed-endpoint-data-serverless='cd ${KIBANA_HOME}/x-pack/solutions/security/plugins/security_solution && yarn test:generate:serverless-dev --numHosts=5 --numDocs=2'

  # Check the code for type errors using TypeScript
  alias start-type-check='cd ${KIBANA_HOME} && node scripts/type_check.js --project tsconfig.json ${PLUGIN_PATH}'

  # Check the code for linting errors using ESLint
  alias start-lint='cd ${KIBANA_HOME} && node scripts/eslint.js ${PLUGIN_PATH}'
  alias start-lint-all='cd ${KIBANA_HOME} && node scripts/eslint.js'

  # Check the code for i18n issues
  alias start-i18n-check='cd ${KIBANA_HOME} && node scripts/i18n_check --ignore-missing'
  alias start-i18n-fix='cd ${KIBANA_HOME} && node scripts/i18n_check.js --fix'

  # Check the code for circular dependencies
  # Add --debug for showing circular dependencies that were whitelisted
  alias start-deps-check='cd ${KIBANA_HOME} && node scripts/find_plugins_with_circular_deps'

 # Work with unit tests (Jest)
  alias ut='f() { TESTS_PATH=${1:-""}; cd ${KIBANA_HOME} && node x-pack/scripts/jest.js $TESTS_PATH -o; };f'
  # Run a single file with unit tests in watch mode: test-tdd x-pack/solutions/security/plugins/security_solution/path/to/my/file.test.ts
  alias test-tdd='f() { TESTS_PATH=${1:-""}; cd ${KIBANA_HOME} && node x-pack/scripts/jest.js $TESTS_PATH --watch -o; };f'
  alias debug-tdd='f() { TESTS_PATH=${1:-""}; cd ${KIBANA_HOME} && node --inspect-brk x-pack/scripts/jest.js --runInBand $TESTS_PATH --watch -o; };f'

  # Work with API integration tests (FTR)
  #
  # Start test server:
  #   cd ${KIBANA_HOME} && node x-pack/scripts/functional_tests_server --config x-pack/test/security_solution_api_integration/test_suites/path/to/config.ts
  # Start test runner for a particular test file:
  #   cd ${KIBANA_HOME} && node x-pack/scripts/functional_test_runner --config x-pack/test/security_solution_api_integration/test_suites/path/to/config.ts --include x-pack/test/security_solution_api_integration/test_suites/path/to/test.ts
  #
  # Debug mode for the test server:
  #   cd ${KIBANA_HOME} && node --inspect-brk x-pack/scripts/functional_tests_server --config x-pack/test/security_solution_api_integration/test_suites/path/to/config.ts

  # node x-pack/scripts/functional_tests_server --config x-pack/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/management/trial_license_complete_tier/configs/ess.config.ts

  # node x-pack/scripts/functional_test_runner --config x-pack/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/management/trial_license_complete_tier/configs/ess.config.ts --include x-pack/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/management/trial_license_complete_tier/bootstrap_prebuilt_rules.ts

  alias test-integration-lists='cd ${KIBANA_HOME}/x-pack && node scripts/functional_tests --config test/lists_api_integration/security_and_spaces/config.ts'
  alias test-integration-server-lists='cd ${KIBANA_HOME}/x-pack && node scripts/functional_tests_server --config test/lists_api_integration/security_and_spaces/config.ts'
  alias test-integration-runner-lists='cd ${KIBANA_HOME}/x-pack && node scripts/functional_test_runner --config test/lists_api_integration/security_and_spaces/config.ts'

  # Work with E2E tests (Cypress)
  alias test-cypress-ess='cd ${KIBANA_HOME}/x-pack/test/security_solution_cypress && yarn cypress:open:ess'
  alias test-cypress-serverless='cd ${KIBANA_HOME}/x-pack/test/security_solution_cypress && yarn cypress:open:serverless'

  # Backport a PR merged to the "main" branch
  alias start-backport='echo "HERE" && cd ${KIBANA_HOME} && node scripts/backport'

  # A few commands for bash to aid in your code searches.
  # Paste the result of ownerpaths into your vscode "files to include" field to search all files we own.
  alias codeowners='cd ${KIBANA_HOME} && cat .github/CODEOWNERS | grep "security-solution\|security-detections-response\|security-detection-rule-management" | cut -d" " -f1 | sed "s@^/@@" | uniq'
  alias ownerpaths='codeowners | paste -sd "," -'

  #FTS debuggging
  alias fts='node x-pack/scripts/functional_tests_server'
  alias ftr='node x-pack/scripts/functional_test_runner'
  # https://nodejs.org/en/learn/getting-started/debugging
  alias fts_debug='node --inspect-wait x-pack/scripts/functional_tests_server'
  alias ftr_debug='node --inspect-wait x-pack/scripts/functional_test_runner'

  # Extra stuff
  alias pr-files-by-owner='f() { (cd ${CODE_HOME}/elastic/kibana-operations/triage && node ./code-owners.js "$@"); unset -f f; }; f'
  alias precommit='node scripts/precommit_hook.js'
}

kbn() {
  kibana-init $1
  cd ${KIBANA_HOME}
}

kibana-init main
