describe Travis::Conditions, 'eval' do
  let(:str)  { 'branch = master' }
  let(:data) { { branch: 'master' } }
  subject { described_class.eval(str, data, opts) }

  describe 'v0' do
    let(:opts) { { version: :v0 } }
    it { should eq true }
  end

  describe 'v1' do
    let(:opts) { { version: :v1 } }
    it { should eq true }
  end
end
