describe Travis::Conditions::V1, 'eval' do
  subject { described_class.eval(str, data) }

  let(:data) { { branch: 'master', tag: tag, env: env } }
  let(:env)  { { foo: 'foo', bar: false } }
  let(:tag)  { nil }

  context do
    context do
      let(:str) { '1' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { '0' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { '""' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'true' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'TRUE' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'false' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'FALSE' }

      it { is_expected.to be false }
    end
  end

  describe 'expressions' do
    context do
      let(:str) { 'NOT branch = foo AND (env(foo) = foo OR tag = wat)' }

      it { is_expected.to be true }
    end

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
      let(:str) { 'env(bar) = true' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'concat(foo, -, bar) = foo-bar' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'concat(branch, -, env(foo), -, env(bar)) = master-foo-false' }

      it { is_expected.to be true }
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
      let(:str) { '1 = 1' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'true = true' }

      it { is_expected.to be true }
    end

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
      let(:str) { 'ENV(foo) = foo' }

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

    context do
      let(:str) { 'env(foo) =~ env(foo)' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(foo) =~ concat("^", env(foo), "$")' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(missing) =~ str' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'str =~ env(missing)' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(missing) =~ ^.*$' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { '^.*$ =~ env(missing)' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'str =~ /[z-a]/' }

      it { expect { subject }.to raise_error Travis::Conditions::ArgumentError, 'Invalid regular expression: /[z-a]/' }
    end
  end

  describe 'in' do
    context do
      let(:str) { 'branch in (foo, master, bar)' }

      it { is_expected.to be true }
    end

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

  describe 'not in' do
    context do
      let(:str) { 'branch not in (foo, master, bar)' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'branch NOT IN (foo, master, bar)' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'branch NOT IN (foo, bar)' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(foo) NOT IN (foo, bar, baz)' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(foo) NOT IN (bar, baz)' }

      it { is_expected.to be true }
    end
  end

  describe 'is' do
    context do
      let(:str) { 'branch is present' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'branch IS present' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'branch IS PRESENT' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'tag IS present' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(foo) IS present' }

      describe 'given an env hash with a string value' do
        let(:env) { { foo: 'foo' } }

        it { is_expected.to be true }
      end

      describe 'given an env hash with a numeric value' do
        let(:env) { { foo: 1 } }

        it { is_expected.to be true }
      end

      describe 'given an env hash with a boolean value' do
        let(:env) { { foo: true } }

        it { is_expected.to be true }
      end

      describe 'given an env strings array with a string value' do
        let(:env) { ['foo=foo'] }

        it { is_expected.to be true }
      end

      describe 'given an env strings array with a numeric value' do
        let(:env) { ['foo=1'] }

        it { is_expected.to be true }
      end

      describe 'given an env strings array with a boolean value' do
        let(:env) { ['foo=true'] }

        it { is_expected.to be true }
      end
    end

    context do
      let(:str) { 'env(bar) IS present' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(baz) IS present' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'branch IS BLANK' }

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
      let(:str) { 'env(foo) IS blank' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(bar) IS blank' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'env(baz) IS blank' }

      it { is_expected.to be true }
    end
  end

  describe 'is not' do
    context do
      let(:str) { 'branch is not present' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'branch IS NOT present' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'tag IS NOT present' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'branch IS NOT blank' }

      it { is_expected.to be true }
    end

    context do
      let(:str) { 'tag IS NOT blank' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(foo) IS NOT present' }

      it { is_expected.to be false }
    end

    context do
      let(:str) { 'env(bar) IS NOT blank' }

      it { is_expected.to be false }
    end
  end

  describe 'booleans' do
    describe 'given a string' do
      let(:data) { { sudo: 'true' } }

      context do
        let(:str) { 'sudo = true' }

        it { is_expected.to be true }
      end

      context do
        let(:str) { 'sudo != false' }

        it { is_expected.to be true }
      end

      context do
        let(:str) { 'sudo IS true' }

        it { is_expected.to be true }
      end

      context do
        let(:str) { 'sudo IS NOT false' }

        it { is_expected.to be true }
      end
    end

    describe 'given a boolean' do
      let(:data) { { sudo: 'true' } }

      context do
        let(:str) { 'sudo = true' }

        it { is_expected.to be true }
      end

      context do
        let(:str) { 'sudo != false' }

        it { is_expected.to be true }
      end

      context do
        let(:str) { 'sudo IS true' }

        it { is_expected.to be true }
      end

      context do
        let(:str) { 'sudo IS NOT false' }

        it { is_expected.to be true }
      end
    end
  end
end
