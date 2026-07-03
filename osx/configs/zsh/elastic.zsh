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
  export KIBANA_DEV_PORT=${KIBANA_PORTS[$KIBANA_VERSION]:-5601}
  export KIBANA_PROXY_PORT=$((KIBANA_DEV_PORT + 10))
  export ES_DEV_PORT=${ES_PORTS[$KIBANA_VERSION]:-9200}
  export ES_TRANSPORT_PORT=$((ES_DEV_PORT + 100))

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

  CURRENT_BRANCH=$(git branch --show-current)

  show-kibana-branches() {
    CYAN='\033[0;36m'; RED='\033[0;31m'; RESET='\033[0m'
    echo ""
    for dir in ~/Code/sdesalas/kibana-main ~/Code/sdesalas/kibana-2nd ~/Code/sdesalas/kibana-3rd ~/Code/sdesalas/kibana-4th ~/Code/sdesalas/kibana-5th ~/Code/sdesalas/kibana-6th ~/Code/sdesalas/kibana-7th ~/Code/sdesalas/kibana-9.0 ~/Code/sdesalas/kibana-9.1; do
      foldername=$(basename "$dir")
      folderbranch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "not a git repo")
      printf "${CYAN}./%s${RESET}  git:(${RED}%s${RESET})\n" "$foldername" "$folderbranch"
    done
    echo ""
  }

  # Delete the folder with Elasticsearch database
  alias clean-es-data='echo "Cleaning KIBANA_VERSION=${KIBANA_VERSION}" && rm -rf $ES_DATA_HOME && echo ".. Done!"'

  # Start bootstrap process because something in package.json changed
  alias start-reset='header "RESETTING [kibana-$KIBANA_VERSION]" && yarn kbn reset && nvm use && NODE_OPTIONS="--max_old_space_size=8192" yarn kbn bootstrap'
  alias start-bootstrap='header "BOOTSTRAPPING [kibana-$KIBANA_VERSION] on [$CURRENT_BRANCH] branch/version" && nvm use && NODE_OPTIONS="--max_old_space_size=8192" yarn kbn bootstrap && NODE_OPTIONS="--max_old_space_size=8192" node scripts/build_kibana_platform_plugins'
  # alias b="header 'ONLY BOOTSTRAPPING \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-bootstrap"
  alias start-bes="start-bootstrap && header 'STARTING ELASTICSEARCH for \"kibana-$KIBANA_VERSION\" on \"$CURRENT_BRANCH\" branch/version' && start-es"
  alias start-bess="start-bootstrap && header 'STARTING ELASTICSEARCH SERVERLESS \"kibana-$KIBANA_VERSION\"  on \"$CURRENT_BRANCH\" branch/version' && start-es-serverless"
  alias start-ces="clean-es-data && start-es"
  alias start-cbes="clean-es-data && start-bootstrap && start-es"

  # Start Elasticsearch
  alias start-es='header "STARTING ELASTICSEARCH for [kibana-$KIBANA_VERSION] on [$CURRENT_BRANCH] branch/version" && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=${ES_DATA_HOME} -E http.port=${ES_DEV_PORT} -E transport.port=${ES_TRANSPORT_PORT}'
  alias start-es-basic='yarn es snapshot --license basic -E xpack.security.authc.api_key.enabled=true -E path.data=${ES_DATA_HOME} -E http.port=${ES_DEV_PORT} -E transport.port=${ES_TRANSPORT_PORT}'
  alias start-es-no-expensive-queries='yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=${ES_DATA_HOME} -E search.allow_expensive_queries=false -E logger.org.elasticsearch.discovery=DEBUG'
  alias start-es-serverless='yarn es serverless --projectType security'
  alias start-es-11th-may='export ES_SNAPSHOT_MANIFEST="https://storage.googleapis.com/kibana-ci-es-snapshots-daily/9.5.0/archives/20260511-022512_32342fb5/manifest.json" && start-es'
  alias start-es-12th-may='export ES_SNAPSHOT_MANIFEST="https://storage.googleapis.com/kibana-ci-es-snapshots-daily/9.5.0/archives/20260512-022202_3cd6e1f7/manifest.json" && start-es'
  alias start-es-13th-may='export ES_SNAPSHOT_MANIFEST="https://storage.googleapis.com/kibana-ci-es-snapshots-daily/9.5.0/archives/20260513-022302_408cc295/manifest.json" && start-es'

  alias set-es-snapshot-11th-may='export ES_SNAPSHOT_MANIFEST="https://storage.googleapis.com/kibana-ci-es-snapshots-daily/9.5.0/archives/20260511-022512_32342fb5/manifest.json"'
  alias set-es-snapshot-12th-may='export ES_SNAPSHOT_MANIFEST="https://storage.googleapis.com/kibana-ci-es-snapshots-daily/9.5.0/archives/20260512-022202_3cd6e1f7/manifest.json"'
  alias set-es-snapshot-13th-may='export ES_SNAPSHOT_MANIFEST="https://storage.googleapis.com/kibana-ci-es-snapshots-daily/9.5.0/archives/20260513-022302_408cc295/manifest.json"'

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

  # Start check
  alias start-check='node script/check'

  # Check the code for type errors using TypeScript
  alias start-type-check='node scripts/type_check.js --project tsconfig.json ${PLUGIN_PATH}'
  alias start-type-check-alerting='node scripts/type_check.js --project x-pack/platform/plugins/shared/alerting/tsconfig.json'
  alias start-type-check-security='NODE_OPTIONS="--max_old_space_size=8192" NODE_OPTIONS="--max_old_space_size=8192" node scripts/type_check.js --project x-pack/solutions/security/plugins/security_solution/tsconfig.json'

  # Lint with types
  alias start-lint-with-types='node scripts/eslint_with_types --fix --project ${PLUGIN_PATH}/tsconfig.json'
  alias start-lint-with-types-alerting='node scripts/eslint_with_types --fix --project x-pack/platform/plugins/shared/alerting/tsconfig.json'
  alias start-lint-with-types-security='NODE_OPTIONS="--max_old_space_size=8192" node scripts/eslint_with_types --fix --project x-pack/solutions/security/plugins/security_solution/tsconfig.json'

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
  alias test-tdd-tm='test-tdd x-pack/platform/plugins/shared/task_manager/'
  alias test-tdd-prebuilt-rules-='test-tdd x-pack/solutions/security/plugins/security_solution/server/lib/detection_engine/prebuilt_rules/api/'

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

  alias fts-alerting-ct-enabled='node x-pack/scripts/functional_tests_server --config x-pack/platform/test/alerting_api_integration/spaces_only/tests/alerting/group6/config_with_change_tracking_enabled.ts'
  alias ftr-alerting-ct-enabled='node scripts/functional_test_runner --bail --config x-pack/platform/test/alerting_api_integration/spaces_only/tests/alerting/group6/config_with_change_tracking_enabled.ts'

  alias fts-alerting-6='node x-pack/scripts/functional_tests_server --config x-pack/platform/test/alerting_api_integration/spaces_only/tests/alerting/group6/config.ts'
  alias ftr-alerting-6='node scripts/functional_test_runner --bail --config x-pack/platform/test/alerting_api_integration/spaces_only/tests/alerting/group6/config.ts'

  alias fts-install-large-bundle='NODE_OPTIONS=--max-old-space-size=8192 node scripts/functional_tests_server --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/common/configs/edge_cases/ess_air_gapped_with_bundled_large_package.config.ts' # 2>&1 | grep --line-buffered -E '"'"'^\s*proc \[es'"'"''
  alias ftr-install-large-bundle='NODE_OPTIONS=--max-old-space-size=8192 node scripts/functional_test_runner --bail --config x-pack/solutions/security/test/security_solution_api_integration/test_suites/detections_response/rules_management/prebuilt_rules/common/configs/edge_cases/ess_air_gapped_with_bundled_large_package.config.ts'

  # Extra stuff
  alias mitm-har='mitmdump --mode reverse:http://localhost:9220 --listen-port 9221 --set hardump=./es-traffic.har --set flow_detail=0'
  alias mitm-har-ssl='mitmdump --mode reverse:https://localhost:9220 --listen-port 9221 --ssl-insecure --set hardump=./es-traffic.har'
  alias pr-files-by-owner='f() { (cd ${CODE_HOME}/elastic/kibana-operations/triage && node ./code-owners.js "$@"); unset -f f; }; f'
  alias precommit='node scripts/precommit_hook.js'
  alias quick-checks='yarn quick-checks'
  alias check-tasks='/Users/sdesalas/Code/sdesalas/kibana-knowledge/scripts/check-tasks.sh'

  alias change-history-to-main='PTH=x-pack/platform/packages/shared/kbn-change-history && rm -rf "../kibana-main/$PTH" && cp -r "./$PTH" "../kibana-main/$PTH"'
  alias change-history-to-2nd='PTH=x-pack/platform/packages/shared/kbn-change-history && rm -rf "../kibana-2nd/$PTH" && cp -r "./$PTH" "../kibana-2nd/$PTH"'
  alias change-history-to-3rd='PTH=x-pack/platform/packages/shared/kbn-change-history && rm -rf "../kibana-3rd/$PTH" && cp -r "./$PTH" "../kibana-3rd/$PTH"'

  alias alerting-to-main='PTH=x-pack/platform/plugins/shared/alerting/server && rm -rf "../kibana-main/$PTH" && cp -r "./$PTH" "../kibana-main/$PTH"'
  alias alerting-to-2nd='PTH=x-pack/platform/plugins/shared/alerting/server && rm -rf "../kibana-2nd/$PTH" && cp -r "./$PTH" "../kibana-2nd/$PTH"'
  alias alerting-to-3rd='PTH=x-pack/platform/plugins/shared/alerting/server && rm -rf "../kibana-3rd/$PTH" && cp -r "./$PTH" "../kibana-3rd/$PTH"'

  # QAF
  alias qaf-show-credentials='qaf elastic-cloud deployments list --show-credentials'
  qaf-deregister() {
    qaf elastic-cloud deployments deregister ${1}
  }
  qaf-remove() {
    qaf elastic-cloud deployments remove ${1}
  }
  qaf-deploy-main-at-commit() {
    EC_API_TRANSPORT_DELAY_ENABLED="true" EC_AUTOSCALING_ENABLED="false" EC_DEPLOYMENT_NAME="main-at-${1:0:7}" EC_ENV="production" EC_PLAN="sdesalas_security_oom_testing" EC_REGION="gcp-us-west2" EC_SSO_ENABLED="false" KIBANA_DOCKER_IMAGE="docker.elastic.co/kibana-ci/kibana-cloud:9.5.0-SNAPSHOT-${1}" STACK_VERSION="9.5.0-SNAPSHOT" qaf elastic-cloud deployments create
  }

  # Memory profiling
  alias start-kibana-profiling='node scripts/kibana --dev  --mem-profile --server.basePath="/kbn" --elasticsearch.hosts="http://localhost:${ES_DEV_PORT}" --server.port=${KIBANA_DEV_PORT} --dev.basePathProxyTarget=${KIBANA_PROXY_PORT} > "kibana.output.$(date -u +%Y%m%dT%H%M).txt" 2>&1'

  # killgroup() {
  #   echo "Parent (PGID: $$) received signal. Killing process group..."
  #   kill -SIGHUP -$$  # Send SIGHUP to all processes in the group (PGID=$$)
  #   wait  # Wait for children to exit
  #   echo "Parent exiting."
  #   exit 0
  # }

  # # Memory profiling
  # start-kibana-profiling() {
  #   trap killgroup SIGINT SIGTERM
  #   KBN_MEM_PROFILE=1 node scripts/kibana --dev --server.basePath="/kbn" --elasticsearch.hosts="http://localhost:${ES_DEV_PORT}" --server.port=${KIBANA_DEV_PORT} --dev.basePathProxyTarget=${KIBANA_PROXY_PORT} > "kibana.output.$(date -u +%Y%m%dT%H%M).txt" 2>&1 &
  #   sleep 5
  #   node plot_memory_profile_csv.mjs kibana-memory-profile-$(date -u +%Y-%m-%dT%H.%M).csv
  # }

  # Heap snapshotting
  alias start-kibana-build='node scripts/build --skip-os-packages --skip-docker-ubi --skip-docker-cloud-fips'
  alias start-kibana-snapshots='NODE_OPTIONS="--require $(pwd)/packages/kbn-heap-snapshot-analyzer-cli/src/heap_track_preload.js" \
HEAP_TRACK_FORCE=1 \
HEAP_TRACK_OUTPUT=/tmp/kibana-tracked-idle.heapsnapshot \
./build/default/kibana-9.5.0-SNAPSHOT-darwin-aarch64/bin/kibana'

  # Prod-like kibana
  alias start-kibana-dist='yarn start --dist --server.basePath="/kbn" --elasticsearch.hosts="http://localhost:${ES_DEV_PORT}" --server.port=${KIBANA_DEV_PORT} --dev.basePathProxyTarget=${KIBANA_PROXY_PORT}'
  #alias start-kibana-build='node scripts/build_kibana_platform_plugins --dist --no-examples'
  alias start-kibana-serve='KBN_MEM_PROFILE=1 node scripts/kibana serve \
  --server.basePath="/kbn" \
  --server.rewriteBasePath=true \
  --elasticsearch.hosts="http://localhost:${ES_DEV_PORT}" \
  --elasticsearch.username=kibana_system \
  --elasticsearch.password=changeme \
  --server.port="${KIBANA_DEV_PORT}"'
  alias start-kibana-build-serve='start-kibana-build && start-kibana-serve'
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
