describe Travis::Conditions, 'eval' do
  subject { described_class.eval(str, data, opts) }

  let(:str)  { 'branch = master' }
  let(:data) { { branch: 'master' } }

  describe 'v0' do
    let(:opts) { { version: :v0 } }

    it { is_expected.to be true }
  end

  describe 'v1' do
    let(:opts) { { version: :v1 } }

    it { is_expected.to be true }
  end
end
