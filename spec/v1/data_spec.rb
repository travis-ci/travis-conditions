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
    let(:env) { ['foo=FOO'] }
    it { expect(subject.env(:foo)).to eq 'FOO' }
    it { expect(subject.env('foo')).to eq 'FOO' }
  end

  describe 'given an empty string it raises ArgumentError' do
    let(:env) { '' }
    it { expect { subject }.to raise_error Travis::Conditions::ArgumentError, 'Cannot normalize data[:env] ("" given)' }
  end
end
