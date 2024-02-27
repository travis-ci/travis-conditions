describe Travis::Conditions::V0, 'eval' do
  subject { described_class.eval(str, data) }

  let(:tag)  { nil }
  let(:data) { { branch: 'master', tag: tag, env: { foo: 'foo' } } }

  describe 'expressions' do
    context do
      let(:str) { 'NOT branch = foo AND (env(foo) = foo OR tag = wat)' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'branch = foo OR env(foo) = foo AND NOT tag = wat' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'branch = foo OR env(foo) = foo AND tag = wat' }

      it { is_expected.to be false }
    end

    context do
      let(:tag) { '0.0.1' }
      let(:str) do
        'tag =~ /^(0|[1-9]\d*)(?:\.(0|[1-9]\d*))?(?:\.(0|[1-9]\d*))?(?:-([\w.-]+))?(?:\+([\w.-]+))?$ AND type IN (push, api)/'
      end

      it { is_expected.to be false }
    end
  end

  describe 'eq' do
    context do
      let(:str) { 'branch = master' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'branch = foo' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(foo) = foo' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(foo) = bar' }

      it { is_expected.to be false }
    end
  end

  describe 'not eq' do
    context do
      let(:str) { 'branch != master' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'branch != foo' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(foo) != foo' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(foo) != bar' }

      it { is_expected.to be true }
    end
  end

  describe 'match' do
    context do
      let(:str) { 'branch =~ ^ma.*$' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'branch =~ ^foo.*$' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(foo) =~ ^foo.*$' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(foo) =~ ^bar.*$' }

      it { is_expected.to be false }
    end
  end

  describe 'in' do
    context do
      let(:str) { 'branch IN (foo, master, bar)' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'branch IN (foo, bar)' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(foo) IN (foo, bar, baz)' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(foo) IN (bar, baz)' }

      it { is_expected.to be false }
    end
  end

  describe 'is' do
    context do
      let(:str) { 'branch IS present' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'tag IS present' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'branch IS blank' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'tag IS blank' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(foo) IS present' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(bar) IS blank' }

      it { is_expected.to be true }
    end
  end
end
