# ------------------------------------------------------------------------------
# Kibana and Security Solution (SIEM)
# https://github.com/elastic/siem-team/blob/master/siem-ui/dev_setup.md

# Initialize Kibana-related env variables and aliases.
# Wrapping aliases in function so they can be updated w/ version.
kibana-init() {
  export KIBANA_VERSION=${1:-master}
  export KIBANA_HOME="$CODE_HOME/elastic/kibana-$KIBANA_VERSION"
  export PLUGIN_NAME=security_solution
  export CASE_PLUGIN_NAME=plugins/case
  export ELASTIC_XPACK_SIEM_LISTS_FEATURE=true

  # Goto directories
  alias kbn=$KIBANA_HOME
  alias go-detections=$KIBANA_HOME/x-pack/plugins/$PLUGIN_NAME/server/lib/detection_engine/scripts
  alias go-lists=$KIBANA_HOME/x-pack/plugins/lists/server/scripts

  # Start bootstrap process because something in package.json changed
  alias start-bootstrap='cd ${KIBANA_HOME} && yarn kbn bootstrap && node scripts/build_kibana_platform_plugins'

  # Start Elasticsearch
  alias start-es='cd ${KIBANA_HOME} && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=$DEV_HOME/es-data'
  alias start-es-for-endpoint='cd ${KIBANA_HOME} && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=$DEV_HOME/es-data -E network.host="0.0.0.0" -E discovery.type="single-node" -E xpack.security.enabled=true'

  # Start Kibana
  alias start-kibana='cd ${KIBANA_HOME} && yarn start'
  alias start-kibana-es-snapshot='cd ${KIBANA_HOME} && yarn start --verbose --xpack.security.enabled=true --xpack.ingestManager.enabled=true --xpack.ingestManager.fleet.enabled=true --xpack.encryptedSavedObjects.encryptionKey=abcdefghijklmnopqrstuvwxyz123456 --host="0.0.0.0"'
  alias start-kibana-real-good='cd ${KIBANA_HOME} && node --max-old-space-size=8000 scripts/kibana.js --dev'

  # Start typecheck for TypeScript
  alias start-type-check='cd ${KIBANA_HOME} && node scripts/type_check.js --project x-pack/tsconfig.json'

  # Start eslint to lint for issues
  alias start-lint='cd ${KIBANA_HOME} && node scripts/eslint.js x-pack/plugins/${PLUGIN_NAME}'
  alias start-lint-all='cd ${KIBANA_HOME} && node scripts/eslint.js'
  alias start-lint-siem='cd ${KIBANA_HOME} && node scripts/eslint.js x-pack/plugins/security_solution'
  alias start-lint-case='cd ${KIBANA_HOME} && node scripts/eslint.js x-pack/plugins/case'

  # Start unit tests
  alias start-jest='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $PLUGIN_NAME'
  alias start-jest-case='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $CASE_PLUGIN_NAME'

  # Start unit tests watch
  alias start-tdd='f() { TESTS_PATH=${1:-""}; cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $TESTS_PATH --watch -o; };f'
  alias start-jest-watch='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js ${PLUGIN_NAME} --watch'
  alias start-jest-watch-size='cd ${KIBANA_HOME}/x-pack && node --max-old-space-size=8192 --optimize-for-size  --max_old_space_size=8192 --optimize_for_size scripts/jest.js $PLUGIN_NAME --watch --max_new_space_size=8192'
  alias start-jest-watch-case='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $CASE_PLUGIN_NAME --watch'

  # Start unit tests coverage
  alias start-jest-coverage='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $PLUGIN_NAME --coverage'
  alias start-jest-coverage-case='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $CASE_PLUGIN_NAME --coverage'

  # Start i18n Check
  alias start-i18n-check='cd ${KIBANA_HOME} && node scripts/i18n_check --ignore-missing'
  alias start-i18n-fix='cd ${KIBANA_HOME} && node scripts/i18n_check.js --fix'

  # Optional if you're using GraphQL, start the generation of graphql
  alias start-bean-gen='cd ${KIBANA_HOME}/x-pack/plugins/$PLUGIN_NAME && node scripts/generate_types_from_graphql.js'

  # Run cyclic dependencies test
  # Add --debug for showing circular dependencies that were whitelisted
  alias start-deps-check='cd ${KIBANA_HOME} && node scripts/find_plugins_with_circular_deps'

  # Test all of my code at once before doing a commit
  alias start-test-all='start-type-check && start-lint && start-i18n-check && start-deps-check && start-jest'
  # alias start-test-all='start-bean-gen && start-i18n-check && start-type-check && start-lint && start-lint-case && start-jest && start-jest-case'

  # Start api integration tests
  alias start-integration='cd ${KIBANA_HOME} && node scripts/functional_tests --config x-pack/test/api_integration/config.ts'

  # Start cypress
  alias start-cypress='cd ${KIBANA_HOME}/x-pack/plugins/$PLUGIN_NAME && yarn cypress:run-as-ci'
  alias start-cypress-spec='f() { cd ${KIBANA_HOME}/x-pack/plugins/$PLUGIN_NAME && yarn cypress:run-as-ci --spec "**/$1" ;};f'
  alias start-cypress-open='cd $KIBANA_HOME/x-pack/plugins/$PLUGIN_NAME && yarn cypress:open-as-ci'
  alias start-cypress-run='cd $KIBANA_HOME/x-pack/plugins/$PLUGIN_NAME && yarn cypress:run'
  alias start-cypress-ci='cd $KIBANA_HOME/x-pack/plugins/$PLUGIN_NAME && yarn cypress:run-as-ci'

  # Open ES Archiver Saved Index -- e.g. es-archiver filebeat/default
  alias es-archiver='f() { cd ${KIBANA_HOME}/x-pack && node ../scripts/es_archiver edit $1/default ;};f'

  # Start Backporting a PR merged w/ master
  alias start-backport='cd ${KIBANA_HOME} && node scripts/backport'

  # Doc Building Aliases
  alias build_docs='$DEV_HOME/docs/build_docs'

  # stack-docs
  alias docbldsec='build_docs --asciidoctor --doc $DEV_HOME/stack-docs/docs/en/$PLUGIN_NAME/index.asciidoc --chunk 1'

  # kibana docs
  alias docbldkbx='build_docs --doc $KIBANA_HOME/docs/index.asciidoc --chunk 1'

  # Delete node_modules and caches
  alias start-burn-the-world='cd $KIBANA_HOME && git clean -fdx -e \.idea\/ -e config\/ && rm -rf node_modules && yarn cache clean'

  # Sync kibana
  alias sync-kibana='cd $KIBANA_HOME && git checkout master && git fetch upstream && git merge upstream/master && git push origin master'
}

kibana-go() {
  kibana-init $1
  cd ${KIBANA_HOME}
  code ${KIBANA_HOME}
}

kibana-init master
