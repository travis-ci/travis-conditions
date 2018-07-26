describe Travis::Conditions::V1::Data do
  let(:env)  { nil }
  let(:data) { { branch: 'branch', env: env } }
  subject { described_class.new(data) }

  it { expect(subject[:branch]).to eq 'branch' }
  it { expect(subject['branch']).to eq 'branch' }

  describe 'given an env hash' do
    let(:env) { { FOO: 'foo' } }
    it { expect(subject.env(:FOO)).to eq 'foo' }
    it { expect(subject.env('FOO')).to eq 'foo' }
  end

  describe 'given an env array' do
    describe 'with a single var' do
      let(:env) { ['FOO=foo'] }
      it { expect(subject.env(:FOO)).to eq 'foo' }
      it { expect(subject.env('FOO')).to eq 'foo' }
    end

    describe 'with several vars on one string' do
      let(:env) { ['FOO=foo BAR=bar'] }
      it { expect(subject.env(:FOO)).to eq 'foo' }
      it { expect(subject.env(:BAR)).to eq 'bar' }
    end

    describe 'with quoted vars' do
      let(:env) { ['FOO="foo bar" BAR="bar baz"'] }
      it { expect(subject.env(:FOO)).to eq 'foo bar' }
      it { expect(subject.env(:BAR)).to eq 'bar baz' }
    end

    describe 'with an escaped space' do
      let(:env) { ['FOO=foo\ bar'] }
      it { expect(subject.env(:FOO)).to eq 'foo\ bar' }
    end

    describe 'with backticks and single quotes' do
      let(:env) { ["FOO=`bar 'baz'`" ] }
      it { expect(subject.env(:FOO)).to eq "`bar 'baz'`" }
    end

    describe 'with backticks and double quotes' do
      let(:env) { ['FOO=`bar "baz"`' ] }
      it { expect(subject.env(:FOO)).to eq '`bar "baz"`' }
    end

    describe 'with a subshell and single quotes' do
      let(:env) { ["FOO=$(bar 'baz')" ] }
      it { expect(subject.env(:FOO)).to eq "$(bar 'baz')" }
    end

    describe 'with a subshell and double quotes' do
      let(:env) { ["FOO=$(bar 'baz')" ] }
      it { expect(subject.env(:FOO)).to eq "$(bar 'baz')" }
    end

    describe 'with a string and a secure env var' do
      let(:env) { ["FOO=foo BAR=bar", { secure: '12345' }] }
      it { expect(subject.env(:FOO)).to eq 'foo' }
    end
  end

  describe 'given a string without an = it raises an ArgumentError' do
    let(:env) { 'foo' }
    xit { expect { subject }.to raise_error Travis::Conditions::ArgumentError, 'Invalid env data ("foo" given)' }
  end

  describe 'given an empty string it raises an ArgumentError' do
    let(:env) { '' }
    xit { expect { subject }.to raise_error Travis::Conditions::ArgumentError, 'Invalid env data ("" given)' }
  end
end
