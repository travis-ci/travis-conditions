# notes
#
# people seem to be confusing `=` (equality) with `IS` (predicate) a lot
# reject builds that fail to parse the condition, instead of ignoring it
#
# docs: change docs to recommend quotes around values in `= "string"`
# docs: change docs to recommend quotes around values in `IN ("list")`
# docs: mention `=` (equality) and `IS` (predicate) are not the same thing, and `branch IS master` does NOT work
# docs: mention NO SHELL CODE PLEASE
# docs: mention reqexp limitations, and recommend using `/.../` first
# docs: make the warning about `env` only having the .travis.yml vars bigger and fatter

def each_fixture(name)
  File.readlines("spec/v1/fixtures/#{name}.txt").each do |str|
    yield str unless str.strip.empty? || str.strip[0] == '#'
  end
end

describe Travis::Conditions::V1, 'real conditions' do
  each_fixture(:failures) do |cond|
    context do
      let(:subject) { described_class.parse(cond) }
      it(cond) { expect { subject }.to raise_error(Travis::Conditions::ParseError) }
    end
  end

  each_fixture(:passes) do |cond|
    context do
      let(:subject) { described_class.parse(cond) }
      it(cond) { expect { subject }.to_not raise_error }
    end
  end

  context do
    let(:cond) do
      %(
        repo = iribeyri/travis-experiments
        AND type != pull_request
        AND (branch = master OR tag =~ ^v[0-9]+\.[0-9]+\.[0-9]+.*$)
      )
    end
    it { expect { described_class.parse(cond) }.to_not raise_error }
  end

  context do
    let(:subject) { described_class.parse(cond) }
    let(:cond) { 'commit_message !~ concat("[skip", env(TRAVIS_JOB_NAME), "]")' }
    it { expect { described_class.parse(cond) }.to_not raise_error }
  end

  describe 'quoted env var' do
    let(:cond) { 'branch = env(FOO)' }
    let(:data) { { branch: 'foo', env: [FOO: '"foo"'] } }
    subject { described_class.eval(cond, data) }
    it { should be true }
  end

  describe 'env vars as hashes' do
    let(:cond) { 'repo = env(SLUG)' }
    let(:data) { { repo: 'owner/name', env: [SLUG: 'owner/name'] } }
    subject { described_class.eval(cond, data) }
    it { should be true }
  end

  describe 'missing env var' do
    let(:cond) { 'branch =~ env(PATTERN)' }
    let(:data) { { branch: 'master', env: [] } }
    subject { described_class.eval(cond, data) }
    it { should be false }
  end
end
