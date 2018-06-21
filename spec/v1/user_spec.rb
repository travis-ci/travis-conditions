# notes
#
# people seem to be confusing `=` (equality) with `IS` (predicate) a lot
# reject builds that fail to parse the condition, instead of ignoring it
#
# docs: change docs to recommend quotes around values in `= "string"`
# docs: change docs to recommend quotes around values in `IN ("list")`
# docs: mention NO SHELL CODE PLEASE
# docs: mention reqexp limitations, and recommend using `/.../` first
# docs: make the warning about `env` only having the .travis.yml vars bigger and fatter

describe Travis::Conditions::V1, 'real conditions' do
  broken = <<~strs.split("\n")
    branch =~ ^(!:release\/) or tag =~ ^version_code\/
    tag =~ (^version_code\/)|(^$)
    branch = develop/pipes=travis
  strs

  used = <<~strs.split("\n")
    ((NOT branch =~ ^develop/.*$) OR (branch = develop/travis)) AND (tag IS blank)
    (NOT branch =~ ^develop/.*$) AND (tag IS blank)
    (branch != master OR type = cron OR type = api)
    (branch = develop/travis) AND (tag IS blank)
    (branch = master) AND (NOT (type IN (api, pull_request)))
    (branch = master) AND (NOT (type IN (api,pull_request)))
    (branch = master) AND (NOT (type IN (push, pull_request)))
    (branch = master) AND (NOT (type IN (push,pull_request)))
    (branch = master) AND (NOT(type IN (api, pull_request)))
    (branch = master) AND (NOT(type IN (api,pull_request)))
    (branch = master) AND (NOT(type IN (push ,pull_request)))
    (branch = master) AND (NOT(type IN (push, pull_request)))
    (branch = master) AND (NOT(type IN (push,pull_request)))
    (type = pull_request) OR (tag IS present)
    (type = push AND NOT (branch = develop)) OR (type = cron)
    NOT branch = master
    NOT branch =~ ^develop/.*$
    NOT tag = "stable"
    NOT tag = stable
    NOT tag =~ \+d2$
    branch = develop/hardening
    branch = develop/pipes-travis
    branch = develop/travis
    branch = master
    branch = master AND NOT(type IN (push,pull_request))
    branch = master AND type = pull_request
    branch = master AND type = push
    branch = master OR tag =~ ^v\d+\.\d+$
    branch = master OR tag IS present
    branch = master OR type = pull_request OR branch =~ ^rc_.*
    branch = staging
    branch = task/ASI-93-auto-update-campaign-performance-summary-for-periscope
    branch = travis
    branch =~ /^release.*$/
    branch =~ /release/
    branch =~ ^develop
    branch =~ ^develop OR branch =~ ^master OR branch =~ ^release
    branch =~ ^release
    branch =~ ^release.*$
    branch =~ ^release/ or tag =~ ^version_code\/
    branch IN (master, ^develop, ^release)
    branch IN (master, develop) OR branch =~ ^release\/.+$ OR branch =~ ^hotfix\/.+$ OR branch =~ ^bugfix\/.+$ OR branch =~ ^support\/.+$ ORtag IS present OR type IN (pull_request, api)
    branch IN (master, development, features)
    branch is blank
    env(TRAVIS_SECURE_ENV_VARS) = true
    fork = false
    not tag =~ ^autobuild
    tag =~ ''
    tag =~ /(^version_code\/)|(^$)/
    tag =~ /^$|\s+/
    tag =~ [0-9]+\.[0-9]+\.[0-9]+
    tag =~ ^\d+(\.\d+)+(-.*)?
    tag =~ ^\d+(\.\d+)+(-.*)? OR branch = travisbuilds-selenium
    tag =~ ^travis*
    tag =~ ^v
    tag =~ ^v
    tag =~ ^version_code/ OR (tag IS NOT present)
    tag =~ ^version_code/ OR tag IS NOT present
    tag =~ ^version_code\/ OR tag =~ ^$
    tag =~ ^version_code\/|^$
    tag IS blank
    tag IS blank
    tag IS present
    tag is blank
    type = push
    type IN (api, cron)
    type IN (push, pull_request)
  strs

  fixed = <<~strs.split("\n").reject(&:empty?)
    true
    1=1
    ( branch NOT IN (master) OR fork = true ) AND type IN (push, api, pull_request)
    (((type != pull_request) AND (branch = master)) OR (tag =~ ^\\d+\\.\\d+\\.\\d+$))
    ((branch = master) OR (tag =~ ^\\d+\\.\\d+\\.\\d+$))
    (branch = master AND type != pull_request) AND (NOT tag =~ ^v)
    (branch = master AND type != pull_request) OR (tag =~ ^v)
    (branch = master OR branch =~ ^infra/$) AND type = push
    (branch = master OR tag =~ ^deploy/) AND (type != pull_request)
    (branch = master) AND (NOT (tag =~prod_))
    (branch = master) AND (tag =~ ^v\\d+\\.\\d+\\.\\d+.*$) AND (type IN (push, pull_request))
    (branch = master) AND (tag =~ ^v\\d+\\.\\d+\\.\\d+.*$) AND type IN (push, pull_request)
    (tag =~ ^prod_)
    (tag =~ ^v) AND (branch = master)
    (tag =~ ^v) AND (branch = release)
    (tag =~ ^v) AND (repo = meniga/mobile-sdk-android)
    (type IN (cron, api)) OR ((tag IS present) AND (tag =~ ^v))
    (type IN (cron, api)) OR (tag =~ ^v)
    (type IN (cron, api)) OR (tag =~ ^v?([0-9]+)\\.([0-9]+)\\.([0-9]+)(?:(?:\\-|\\+)([0-9A-Za-z-]+(?:\\.[0-9A-Za-z-]+)*)){0,2}$)
    NOT type IN (pull_request) AND (branch = master OR tag =~ ^v[1-9])
    TRAVIS_PULL_REQUEST = false
    branch = master AND tag is blank AND fork is false AND repo = head_repo AND type != pull_request
    branch = master AND tag is blank AND fork is false AND type != pull_request
    branch = master AND type = push
    branch = master AND type == pull_request
    branch IN (master, dev_package)
    branch NOT IN (master) OR fork = true
    branch in (master, dev) OR type == pull
    env(FOO) = env(TRAVIS_SECURE_ENV_VARS)
    env(IS_TAGS_ONLY) = env(NO)
    env(IS_TAGS_ONLY) = env(NO) AND env(YES) IN (env(IS_FULL_REGRESSION), env(IS_READY_TO_BUILD))
    env(PRIOR_VERSION) != env(RELEASE_VERSION)
    env(PRIOR_VERSION) IS present AND env(PRIOR_VERSION) != env(RELEASE_VERSION) AND branch = master AND type = push AND repo = cotsog/travis_ci_prod_regular
    env(PRIOR_VERSION) IS present AND env(PRIOR_VERSION) != env(RELEASE_VERSION) AND branch = master AND type = push AND repo = justien/travis_conditional_stages
    env(PRIOR_VERSION) IS present AND env(PRIOR_VERSION) != env(RELEASE_VERSION) AND branch = master AND type = push AND repo = plus3it/terraform-aws-watchmaker
    env(TRAVIS_SECURE_ENV_VARS) IS true
    env(env_name) IS blank
    env(env_name) IS present
    tag =~ ^version_code/ OR tag IS NOT present
    tag IS NOT blank
    tag IS NOT present
    tag IS blank
    tag IS present
    tag IS present OR branch == master
    true = false
    type = pull_request
    type IN (api, cron)
    type IN (push, cron) AND (NOT branch =~ [0-9]{8,})
    type IN (push, cron) AND (tag =~ ^$)
    type IN (push, cron) AND NOT (branch =~ [0-9]{8,})
    type NOT IN (api, cron)
    type NOT IN (cron)

    env(FORCE_REBUILD) ~= ^true$
    env(REBUILD) ~= ^true$ OR env(FORCE_REBUILD) ~= ^true$ OR (branch = master AND type = push)
    type = cron OR env(TEST_SQLITE) ~= ^true$

    branch = master AND tag is blank AND fork is false AND repo = head_repo AND type != pull_request
    tags IS blank
    type = cron OR env(TEST_SQLITE) IS true
    tag !~ \\\n ^v-

    env(REBUILD) OR env(FORCE_REBUILD) OR branch = master
    env(DOCKER_BUILD)
    env(DOCKER_PASSWORD)
    type = cron OR env(TEST_SQLITE)

    type != pull_request AND ( branch =~ ^release$ OR branch =~ ^release-(\d).(\d).(\d)$ )
    type != pull_request AND (branch =~ ^release$ OR branch =~ ^release-(\d).(\d).(\d)$)
    (branch = master) OR (branch =~ ^release/) OR (tag is present)
  strs

  kaputt = <<~strs.split("\n")
    # IS used for comparison
    (branch = dev) AND (type IS cron)
    (repo IS 2m/sssio) AND (tag =~ ^v)
    branch IS master
    type IS push

    # broken IN list
    (type = pull_request) AND (branch IN dev)

    # = followed by IN
    branch = IN (master, dev_package)

    # missing boolean operand
    branch = master AND ( tag =~ ^deploy/ OR )

    # NON instead of NOT
    branch = master AND type NON IN (pull_request)

    # missing AND or OR
    branch = master NOT type = pull_request

    # triple operator
    branch = type = pull_request

    # missing IS
    tag NOT present

    # bash code
    env(FORCE_JOBS) IS blank && (branch = ${MASTER_BRANCH} OR type = pull_request)

    # operator !=~
    branch = master or branch !=~ ^renovate/

    # needs /.../ around the pattern
    env(TRAVIS_COMMIT_MESSAGE) =~ ^Replace Conditionalaaa$

    # missing quotes
    env(TRAVIS_COMMIT_MESSAGE) IN (Replace Conditional)
    env(TRAVIS_COMMIT_MESSAGE) = Replace conditional
  strs

  strs = used + fixed

  strs.each do |str|
    context do
      let(:subject) { described_class.parse(str) }
      it(str) { expect { subject }.to_not raise_error }
    end
  end

  context do
    let(:str) do
      %(
        repo = iribeyri/travis-experiments
        AND type != pull_request
        AND (branch = master OR tag =~ ^v[0-9]+\.[0-9]+\.[0-9]+.*$)
      )
    end
    it { expect { described_class.parse(str) }.to_not raise_error }
  end
end
