describe Travis::Conditions::V1, 'eval' do
  let(:tag)  { nil }
  let(:data) { { branch: 'master', tag: tag, env: { foo: 'foo', bar: false } } }
  subject { described_class.eval(str, data) }

  context do
    context do
      let(:str) { '1' }
      it { should be true }
    end

    context do
      let(:str) { '0' }
      it { should be true }
    end

    context do
      let(:str) { '""' }
      it { should be true }
    end

    context do
      let(:str) { 'true' }
      it { should be true }
    end

    context do
      let(:str) { 'TRUE' }
      it { should be true }
    end

    context do
      let(:str) { 'false' }
      it { should be false }
    end

    context do
      let(:str) { 'FALSE' }
      it { should be false }
    end
  end

  describe 'expressions' do
    context do
      let(:str) { 'NOT branch = foo AND (env(foo) = foo OR tag = wat)' }
      it { should be true }
    end

    context do
      let(:str) { 'NOT branch = foo AND (env(foo) = foo OR tag = wat)' }
      it { should be true }
    end

    context do
      let(:str) { 'branch = foo OR env(foo) = foo AND NOT tag = wat' }
      it { should be true }
    end

    context do
      let(:str) { 'branch = foo OR env(foo) = foo AND tag = wat' }
      it { should be false }
    end

    context do
      let(:str) { 'env(bar) = true' }
      it { should be false }
    end

    context do
      let(:tag) { '0.0.1' }
      let(:str) { 'tag =~ /^(0|[1-9]\d*)(?:\.(0|[1-9]\d*))?(?:\.(0|[1-9]\d*))?(?:-([\w.-]+))?(?:\+([\w.-]+))?$ AND type IN (push, api)/' }
      it { should be false }
    end
  end

  describe 'eq' do
    context do
      let(:str) { '1 = 1' }
      it { should be true }
    end

    context do
      let(:str) { 'true = true' }
      it { should be true }
    end

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

  describe 'not eq' do
    context do
      let(:str) { 'branch != master' }
      it { should be false }
    end

    context do
      let(:str) { 'branch != foo' }
      it { should be true }
    end

    context do
      let(:str) { 'env(foo) != foo' }
      it { should be false }
    end

    context do
      let(:str) { 'env(foo) != bar' }
      it { should be true }
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

  describe 'not in' do
    context do
      let(:str) { 'branch NOT IN (foo, master, bar)' }
      it { should be false }
    end

    context do
      let(:str) { 'branch NOT IN (foo, bar)' }
      it { should be true }
    end

    context do
      let(:str) { 'env(foo) NOT IN (foo, bar, baz)' }
      it { should be false }
    end

    context do
      let(:str) { 'env(foo) NOT IN (bar, baz)' }
      it { should be true }
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

  describe 'is not' do
    context do
      let(:str) { 'branch IS NOT present' }
      it { should be false }
    end

    context do
      let(:str) { 'tag IS NOT present' }
      it { should be true }
    end

    context do
      let(:str) { 'branch IS NOT blank' }
      it { should be true }
    end

    context do
      let(:str) { 'tag IS NOT blank' }
      it { should be false }
    end

    context do
      let(:str) { 'env(foo) IS NOT present' }
      it { should be false }
    end

    context do
      let(:str) { 'env(bar) IS NOT blank' }
      it { should be false }
    end
  end

  describe 'booleans' do
    describe 'given a string' do
      let(:data) { { sudo: 'true' } }

      context do
        let(:str) { 'sudo = true' }
        it { should be true }
      end

      context do
        let(:str) { 'sudo != false' }
        it { should be true }
      end

      context do
        let(:str) { 'sudo IS true' }
        it { should be true }
      end

      context do
        let(:str) { 'sudo IS NOT false' }
        it { should be true }
      end
    end

    describe 'given a boolean' do
      let(:data) { { sudo: 'true' } }

      context do
        let(:str) { 'sudo = true' }
        it { should be true }
      end

      context do
        let(:str) { 'sudo != false' }
        it { should be true }
      end

      context do
        let(:str) { 'sudo IS true' }
        it { should be true }
      end

      context do
        let(:str) { 'sudo IS NOT false' }
        it { should be true }
      end
    end
  end
end
