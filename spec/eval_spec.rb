describe Travis::Conditions, 'eval' do
  let(:data) { { branch: 'master', env: { foo: 'foo' } } }
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

    context do
      let(:str) { 'env(foo) = foo' }
      it { should be true }
    end

    context do
      let(:str) { 'env(foo) = bar' }
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

    context do
      let(:str) { 'env(foo) =~ ^foo.*$' }
      it { should be true }
    end

    context do
      let(:str) { 'env(foo) =~ ^bar.*$' }
      it { should be false }
    end
  end

  describe 'in' do
    context do
      let(:str) { 'branch IN (foo, master, bar)' }
      it { should be true }
    end

    context do
      let(:str) { 'branch IN (foo, bar)' }
      it { should be false }
    end

    context do
      let(:str) { 'env(foo) IN (foo, bar, baz)' }
      it { should be true }
    end

    context do
      let(:str) { 'env(foo) IN (bar, baz)' }
      it { should be false }
    end
  end

  describe 'is' do
    context do
      let(:str) { 'branch IS present' }
      it { should be true }
    end

    context do
      let(:str) { 'tag IS present' }
      it { should be false }
    end

    context do
      let(:str) { 'branch IS blank' }
      it { should be false }
    end

    context do
      let(:str) { 'tag IS blank' }
      it { should be true }
    end

    context do
      let(:str) { 'env(foo) IS present' }
      it { should be true }
    end

    context do
      let(:str) { 'env(bar) IS blank' }
      it { should be true }
    end
  end
end
