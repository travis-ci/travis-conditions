describe Travis::Conditions, 'eval' do
  let(:data) { { branch: 'master' } }
  subject { described_class.eval(str, data) }

  describe 'eq' do
    context do
      let(:str) { 'branch = master' }
      it { should be true }
    end

    context do
      let(:str) { 'branch = foo' }
      it { should be false }
    end
  end

  describe 'match' do
    context do
      let(:str) { 'branch =~ ^ma.*$' }
      it { should be true }
    end

    context do
      let(:str) { 'branch =~ ^foo.*$' }
      it { should be false }
    end
  end

  describe 'include' do
    context do
      let(:str) { 'branch IN (foo, master, bar)' }
      it { should be true }
    end

    context do
      let(:str) { 'branch IN (foo, bar)' }
      it { should be false }
    end
  end
end
