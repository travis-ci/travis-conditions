describe Travis::Conditions::V1::Data do
  let(:env)  { nil }
  let(:data) { { branch: 'branch', env: env } }
  subject { described_class.new(data) }

  it { expect(subject[:branch]).to eq 'branch' }
  it { expect(subject['branch']).to eq 'branch' }

  describe 'given an env hash' do
    let(:env) { { foo: 'FOO' } }
    it { expect(subject.env(:foo)).to eq 'FOO' }
    it { expect(subject.env('foo')).to eq 'FOO' }
  end

  describe 'given an env array' do
    describe 'with a single var' do
      let(:env) { ['foo=FOO'] }
      it { expect(subject.env(:foo)).to eq 'FOO' }
      it { expect(subject.env('foo')).to eq 'FOO' }
    end

    describe 'with several vars on one string' do
      let(:env) { ['foo=FOO bar=BAR'] }
      it { expect(subject.env(:foo)).to eq 'FOO' }
      it { expect(subject.env(:bar)).to eq 'BAR' }
    end

    describe 'with quoted vars' do
      let(:env) { ['foo="FOO BAR" bar="BAR BAZ"'] }
      it { expect(subject.env(:foo)).to eq 'FOO BAR' }
      it { expect(subject.env(:bar)).to eq 'BAR BAZ' }
    end
  end

  describe 'given a string without an = it raises an ArgumentError' do
    let(:env) { 'foo' }
    it { expect { subject }.to raise_error Travis::Conditions::ArgumentError, 'Invalid env data ("foo" given)' }
  end

  describe 'given an empty string it raises an ArgumentError' do
    let(:env) { '' }
    it { expect { subject }.to raise_error Travis::Conditions::ArgumentError, 'Invalid env data ("" given)' }
  end
end
