# ------------------------------------------------------------------------------
# Kibana and Security Solution (SIEM)
# https://github.com/elastic/siem-team/blob/master/siem-ui/dev_setup.md

# yarn kbn bootstrap now often takes ~30m.
# This is a temp measure https://github.com/elastic/kibana/pull/91012
export BUILD_TS_REFS_CACHE_ENABLE=true

# Initialize Kibana-related env variables and aliases.
# Wrapping aliases in function so they can be updated w/ version.
kibana-init() {
  export KIBANA_VERSION=${1:-main}
  export KIBANA_HOME="$CODE_HOME/elastic/kibana-$KIBANA_VERSION"
  export PLUGIN_NAME="security_solution"
  export PLUGIN_PATH="x-pack/plugins/${PLUGIN_NAME}"
  export ELASTIC_XPACK_SIEM_LISTS_FEATURE=true

  # Start bootstrap process because something in package.json changed
  alias start-bootstrap='cd ${KIBANA_HOME} && yarn kbn bootstrap && node scripts/build_kibana_platform_plugins'

  # Start Elasticsearch
  alias start-es='cd ${KIBANA_HOME} && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=$DEV_HOME/es-data'
  alias start-es-for-endpoint='cd ${KIBANA_HOME} && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=$DEV_HOME/es-data -E network.host="0.0.0.0" -E discovery.type="single-node" -E xpack.security.enabled=true'

  # Start Kibana
  alias start-kibana='cd ${KIBANA_HOME} && yarn start'
  alias start-kibana-es-snapshot='cd ${KIBANA_HOME} && yarn start --xpack.encryptedSavedObjects.encryptionKey=abcdefghijklmnopqrstuvwxyz123456 --host="0.0.0.0"'
  alias start-kibana-real-good='cd ${KIBANA_HOME} && node --max-old-space-size=8000 scripts/kibana.js --dev'

  # Start typecheck for TypeScript
  alias start-type-check='cd ${KIBANA_HOME} && node scripts/type_check.js --project tsconfig.json ${PLUGIN_PATH}'

  # Start eslint to lint for issues
  alias start-lint='cd ${KIBANA_HOME} && node scripts/eslint.js ${PLUGIN_PATH}'
  alias start-lint-all='cd ${KIBANA_HOME} && node scripts/eslint.js'

  # Start unit tests
  alias start-jest='cd ${KIBANA_HOME} && node x-pack/scripts/jest.js ${PLUGIN_NAME}'

  # Start unit tests watch
  alias start-tdd='f() { TESTS_PATH=${1:-""}; cd ${KIBANA_HOME} && node x-pack/scripts/jest.js $TESTS_PATH --watch -o; };f'
  alias start-jest-watch='cd ${KIBANA_HOME} && node x-pack/scripts/jest.js ${PLUGIN_NAME} --watch'
  alias start-jest-watch-size='cd ${KIBANA_HOME} && node --max-old-space-size=8192 --optimize-for-size  --max_old_space_size=8192 --optimize_for_size x-pack/scripts/jest.js $PLUGIN_NAME --watch --max_new_space_size=8192'

  # Start unit tests coverage
  alias start-jest-coverage='cd ${KIBANA_HOME} && node x-pack/scripts/jest.js ${PLUGIN_NAME} --coverage'

  # Start i18n Check
  alias start-i18n-check='cd ${KIBANA_HOME} && node scripts/i18n_check --ignore-missing'
  alias start-i18n-fix='cd ${KIBANA_HOME} && node scripts/i18n_check.js --fix'

  # Optional if you're using GraphQL, start the generation of graphql
  alias start-bean-gen='cd ${KIBANA_HOME}/${PLUGIN_PATH} && node scripts/generate_types_from_graphql.js'

  # Run cyclic dependencies test
  # Add --debug for showing circular dependencies that were whitelisted
  alias start-deps-check='cd ${KIBANA_HOME} && node scripts/find_plugins_with_circular_deps'

  # Test all of my code at once before doing a commit
  alias start-test-all='start-type-check && start-lint && start-i18n-check && start-deps-check && start-jest'

  # Start api integration tests
  alias start-integration='cd ${KIBANA_HOME} && node scripts/functional_tests --config x-pack/test/api_integration/config.ts'
  alias start-integration-server='cd ${KIBANA_HOME} && node scripts/functional_tests_server --config x-pack/test/api_integration/config.ts'
  alias start-integration-runner='cd ${KIBANA_HOME} && node scripts/functional_test_runner --config x-pack/test/api_integration/config.ts'

  alias start-integration-de-basic='cd ${KIBANA_HOME} && node scripts/functional_tests --config x-pack/test/detection_engine_api_integration/basic/config.ts'
  alias start-integration-server-de-basic='cd ${KIBANA_HOME} && node scripts/functional_tests_server --config x-pack/test/api_integration/config.ts'
  alias start-integration-runner-de-basic='cd ${KIBANA_HOME} && node scripts/functional_test_runner --config x-pack/test/api_integration/config.ts'

  alias start-integration-de-trial='cd ${KIBANA_HOME} && node scripts/functional_tests --config x-pack/test/detection_engine_api_integration/security_and_spaces/config.ts'
  alias start-integration-server-de-trial='cd ${KIBANA_HOME} && node scripts/functional_tests_server --config x-pack/test/detection_engine_api_integration/security_and_spaces/config.ts'
  alias start-integration-runner-de-trial='cd ${KIBANA_HOME} && node scripts/functional_test_runner --config x-pack/test/detection_engine_api_integration/security_and_spaces/config.ts'

  alias start-integration-lists='cd ${KIBANA_HOME} && node scripts/functional_tests --config x-pack/test/lists_api_integration/security_and_spaces/config.ts'
  alias start-integration-server-lists='cd ${KIBANA_HOME} && node scripts/functional_tests_server --config x-pack/test/lists_api_integration/security_and_spaces/config.ts'
  alias start-integration-runner-lists='cd ${KIBANA_HOME} && node scripts/functional_test_runner --config x-pack/test/lists_api_integration/security_and_spaces/config.ts'

  # Start cypress
  alias start-cypress='cd ${KIBANA_HOME}/${PLUGIN_PATH} && yarn cypress:run-as-ci'
  alias start-cypress-spec='f() { cd ${KIBANA_HOME}/${PLUGIN_PATH} && yarn cypress:run-as-ci --spec "**/$1" ;};f'
  alias start-cypress-open='cd ${KIBANA_HOME}/${PLUGIN_PATH} && yarn cypress:open-as-ci'
  alias start-cypress-run='cd ${KIBANA_HOME}/${PLUGIN_PATH} && yarn cypress:run'
  alias start-cypress-ci='cd ${KIBANA_HOME}/${PLUGIN_PATH} && yarn cypress:run-as-ci'

  # Open ES Archiver Saved Index -- e.g. es-archiver filebeat/default
  alias es-archiver='f() { cd ${KIBANA_HOME}/x-pack && node ../scripts/es_archiver edit $1/default ;};f'

  # Start Backporting a PR merged w/ main
  alias start-backport='cd ${KIBANA_HOME} && node scripts/backport'

  # Doc Building Aliases
  alias build_docs='$DEV_HOME/docs/build_docs'

  # stack-docs
  alias docbldsec='build_docs --asciidoctor --doc $DEV_HOME/stack-docs/docs/en/$PLUGIN_NAME/index.asciidoc --chunk 1'

  # kibana docs
  alias docbldkbx='build_docs --doc ${KIBANA_HOME}/docs/index.asciidoc --chunk 1'

  # Delete node_modules and caches
  alias start-burn-the-world='cd ${KIBANA_HOME} && git clean -fdx -e \.idea\/ -e config\/ && rm -rf node_modules && yarn cache clean'

  # Sync kibana
  alias sync-kibana='cd ${KIBANA_HOME} && git checkout main && git fetch upstream && git merge upstream/main && git push origin main'
}

kbn() {
  kibana-init $1
  cd ${KIBANA_HOME}
}

kibana-init main
