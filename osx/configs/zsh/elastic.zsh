# ------------------------------------------------------------------------------
# Vault (secrets storage)
# https://github.com/elastic/infra/blob/master/docs/vault/README.md

export VAULT_ADDR=https://secrets.elastic.co:8200

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
  export ES_DATA_HOME="$DEV_HOME/elastic/es-data-$KIBANA_VERSION"
  export PLUGIN_NAME="security_solution"
  export PLUGIN_PATH="x-pack/plugins/${PLUGIN_NAME}"
  export ELASTIC_XPACK_SIEM_LISTS_FEATURE=true

  # Delete the folder with Elasticsearch database
  alias clean-es-data='rm -rf $ES_DATA_HOME'

  # Start bootstrap process because something in package.json changed
  alias start-bootstrap='cd ${KIBANA_HOME} && yarn kbn bootstrap && node scripts/build_kibana_platform_plugins'

  # Start Elasticsearch
  alias start-es='cd ${KIBANA_HOME} && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=${ES_DATA_HOME}'
  alias start-es-for-endpoint='cd ${KIBANA_HOME} && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=${ES_DATA_HOME} -E network.host="0.0.0.0" -E discovery.type="single-node" -E xpack.security.enabled=true'

  # Start Kibana
  alias start-kibana='cd ${KIBANA_HOME} && yarn start'

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
  # Kibana running for integration tests: http://localhost:5620/
  # Basic license
  #   cd ${KIBANA_HOME}/x-pack && node scripts/functional_tests_server --config x-pack/test/detection_engine_api_integration/basic/config.ts
  #   cd ${KIBANA_HOME}/x-pack && node scripts/functional_test_runner --config x-pack/test/detection_engine_api_integration/basic/config.ts --include x-pack/test/detection_engine_api_integration/basic/tests/find_rules.ts
  # Trial license
  #   cd ${KIBANA_HOME}/x-pack && node scripts/functional_tests_server --config x-pack/test/detection_engine_api_integration/security_and_spaces/group1/config.ts
  #   cd ${KIBANA_HOME}/x-pack && node scripts/functional_test_runner --config x-pack/test/detection_engine_api_integration/security_and_spaces/group1/config.ts --include x-pack/test/detection_engine_api_integration/security_and_spaces/group1/create_threat_matching.ts
  # Debug mode for the test server
  #   cd ${KIBANA_HOME}/x-pack && node --inspect-brk scripts/functional_tests_server.js --config test/detection_engine_api_integration/security_and_spaces/config.ts

  alias start-integration-lists='cd ${KIBANA_HOME}/x-pack && node scripts/functional_tests --config test/lists_api_integration/security_and_spaces/config.ts'
  alias start-integration-server-lists='cd ${KIBANA_HOME}/x-pack && node scripts/functional_tests_server --config test/lists_api_integration/security_and_spaces/config.ts'
  alias start-integration-runner-lists='cd ${KIBANA_HOME}/x-pack && node scripts/functional_test_runner --config test/lists_api_integration/security_and_spaces/config.ts'

  # Start cypress
  alias start-cypress-open='cd ${KIBANA_HOME}/${PLUGIN_PATH} && yarn cypress:open'
  alias start-cypress-spec='f() { cd ${KIBANA_HOME}/${PLUGIN_PATH} && yarn cypress:run-as-ci --spec "**/$1" ;};f'

  # Use resolver_generator script to generate fake source events from Endpoint Security
  alias seed-endpoint-data='cd ${KIBANA_HOME} && node x-pack/plugins/security_solution/scripts/endpoint/resolver_generator.js --node http://elastic:changeme@127.0.0.1:9200 --kibana http://elastic:changeme@0.0.0.0:5601/kbn --numHosts=5 --numDocs=2'

  # Open ES Archiver Saved Index -- e.g. es-archiver filebeat/default
  alias es-archiver='f() { cd ${KIBANA_HOME}/x-pack && node ../scripts/es_archiver edit $1/default ;};f'

  # Start Backporting a PR merged w/ main
  alias start-backport='cd ${KIBANA_HOME} && node scripts/backport'

  # These docs are for the internal [Plugin API docs](https://docs.elastic.dev/kibana-dev-docs/api/securitySolution),
  # which describe all the different Kibana Plugin's exported members and client/server interface. They're used mostly
  # by Kibana developers for when needing to interact with other plugins. They're generated (and checked in) by a daily
  # buildkite build, or can be built manually via the command below. Metrics for a plugin's documented exports are
  # provided in the monthly developer newsletter as well.
  alias start_build_api_docs='cd ${KIBANA_HOME} && node scripts/build_api_docs --plugin securitysolution --stats comments'

  # Sync kibana
  alias sync-kibana='cd ${KIBANA_HOME} && git checkout main && git fetch upstream && git merge upstream/main && git push origin main'

  # A few commands for bash to aid in your code searches.
  # Paste the result of ownerpaths into your vscode "files to include" field to search all files we own.
  alias codeowners='cd ${KIBANA_HOME} && cat .github/CODEOWNERS | grep "security-solution\|detections-response\|security-solution-platform" | cut -d" " -f1 | sed "s@^/@@" | uniq'
  alias ownerpaths='codeowners | paste -sd "," -'
}

kbn() {
  kibana-init $1
  cd ${KIBANA_HOME}
}

kibana-init main
