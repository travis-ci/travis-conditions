describe Travis::Conditions::V0 do
  subject { described_class.parse(str, keys: keys) }

  let(:keys) { [:foo] }

  describe 'eq' do
    context do
      let(:str) { 'foo = bar' }

      it { is_expected.to eq [:eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo =bar' }

      it { is_expected.to eq [:eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo= bar' }

      it { is_expected.to eq [:eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo=bar' }

      it { is_expected.to eq [:eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo = "bar baz"' }

      it { is_expected.to eq [:eq, 'foo', 'bar baz'] }
    end

    context do
      let(:str) { 'foo="bar baz"' }

      it { is_expected.to eq [:eq, 'foo', 'bar baz'] }
    end

    context do
      let(:str) { 'env(foo) = "bar baz"' }

      it { is_expected.to eq [:eq, [:env, 'foo'], 'bar baz'] }
    end

    context do
      let(:str) { 'foo = true' }

      it { is_expected.to eq [:eq, 'foo', 'true'] }
    end
  end

  describe 'not eq' do
    context do
      let(:str) { 'foo != bar' }

      it { is_expected.to eq [:not_eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo !=bar' }

      it { is_expected.to eq [:not_eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo!= bar' }

      it { is_expected.to eq [:not_eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo!=bar' }

      it { is_expected.to eq [:not_eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo != "bar baz"' }

      it { is_expected.to eq [:not_eq, 'foo', 'bar baz'] }
    end

    context do
      let(:str) { 'foo!="bar baz"' }

      it { is_expected.to eq [:not_eq, 'foo', 'bar baz'] }
    end

    context do
      let(:str) { 'env(foo) != "bar baz"' }

      it { is_expected.to eq [:not_eq, [:env, 'foo'], 'bar baz'] }
    end
  end

  describe 'match' do
    context do
      let(:str) { 'foo =~ ^v[0-9]$' }

      it { is_expected.to eq [:match, 'foo', '^v[0-9]$'] }
    end

    context do
      let(:str) { 'env(foo) =~ ^v[0-9]$' }

      it { is_expected.to eq [:match, [:env, 'foo'], '^v[0-9]$'] }
    end

    context do
      let(:str) { 'foo =~ /^v[0-9]$/' }

      it { is_expected.to eq [:match, 'foo', '^v[0-9]$'] }
    end

    context do
      let(:str) { 'NOT (foo =~ /^v[0-9]$/)' }

      it { is_expected.to eq [:not, [:match, 'foo', '^v[0-9]$']] }
    end
  end

  describe 'not match' do
    context do
      let(:str) { 'foo !~ ^v[0-9]$' }

      it { is_expected.to eq [:not_match, 'foo', '^v[0-9]$'] }
    end

    context do
      let(:str) { 'env(foo) !~ ^v[0-9]$' }

      it { is_expected.to eq [:not_match, [:env, 'foo'], '^v[0-9]$'] }
    end
  end

  describe 'in' do
    context do
      let(:str) { 'foo IN (bar)' }

      it { is_expected.to eq [:in, 'foo', ['bar']] }
    end

    context do
      let(:str) { 'foo IN (bar, baz, buz)' }

      it { is_expected.to eq [:in, 'foo', %w[bar baz buz]] }
    end

    context do
      let(:str) { 'foo IN (bar, "baz, buz")' }

      it { is_expected.to eq [:in, 'foo', ['bar', 'baz, buz']] }
    end

    context do
      let(:str) { 'env(foo) IN (bar, "baz, buz")' }

      it { is_expected.to eq [:in, [:env, 'foo'], ['bar', 'baz, buz']] }
    end
  end

  describe 'is' do
    context do
      let(:str) { 'foo IS present' }

      it { is_expected.to eq [:is, 'foo', :present] }
    end

    context do
      let(:str) { 'foo IS PRESENT' }

      it { is_expected.to eq [:is, 'foo', :present] }
    end

    context do
      let(:str) { 'foo IS blank' }

      it { is_expected.to eq [:is, 'foo', :blank] }
    end

    context do
      let(:str) { 'foo IS BLANK' }

      it { is_expected.to eq [:is, 'foo', :blank] }
    end

    context do
      let(:str) { 'env(foo) IS BLANK' }

      it { is_expected.to eq [:is, [:env, 'foo'], :blank] }
    end
  end

  describe 'boolean' do
    let(:keys) { %i[a b c d] }

    context do
      let(:str) { 'a=1 OR b=2 AND c=3 OR d=4' }

      it { is_expected.to eq [:or, [:eq, 'a', '1'], [:or, [:and, [:eq, 'b', '2'], [:eq, 'c', '3']], [:eq, 'd', '4']]] }
    end

    context do
      let(:str) { '(a=1) OR (b=2) AND (c=3) OR (d=4)' }

      it { is_expected.to eq [:or, [:eq, 'a', '1'], [:or, [:and, [:eq, 'b', '2'], [:eq, 'c', '3']], [:eq, 'd', '4']]] }
    end

    context do
      let(:str) { '(a=1 OR b=2) AND (c=3 OR d=4)' }

      it { is_expected.to eq [:and, [:or, [:eq, 'a', '1'], [:eq, 'b', '2']], [:or, [:eq, 'c', '3'], [:eq, 'd', '4']]] }
    end

    context do
      let(:str) { 'env(a)=1 OR env(b)=2 AND c=3' }

      it { is_expected.to eq [:or, [:eq, [:env, 'a'], '1'], [:and, [:eq, [:env, 'b'], '2'], [:eq, 'c', '3']]] }
    end

    context do
      let(:str) { '(env(a)=1) OR (env(b)=2) AND (c=3)' }

      it { is_expected.to eq [:or, [:eq, [:env, 'a'], '1'], [:and, [:eq, [:env, 'b'], '2'], [:eq, 'c', '3']]] }
    end

    context do
      let(:str) { '(env(a)=1 OR env(b)=2) AND c=3' }

      it { is_expected.to eq [:and, [:or, [:eq, [:env, 'a'], '1'], [:eq, [:env, 'b'], '2']], [:eq, 'c', '3']] }
    end

    context do
      let(:str) { 'a IN (1) OR b IN (2) AND c IN (3)' }

      it { is_expected.to eq [:or, [:in, 'a', ['1']], [:and, [:in, 'b', ['2']], [:in, 'c', ['3']]]] }
    end

    context do
      let(:str) { '(a IN (1) OR b IN (2)) AND (c IN (3))' }

      it { is_expected.to eq [:and, [:or, [:in, 'a', ['1']], [:in, 'b', ['2']]], [:in, 'c', ['3']]] }
    end

    context do
      let(:str) { 'a IS present OR b IS blank AND c IS present' }

      it { is_expected.to eq [:or, [:is, 'a', :present], [:and, [:is, 'b', :blank], [:is, 'c', :present]]] }
    end

    context do
      let(:str) { '(a IS present OR (b IS blank)) AND (c IS present)' }

      it { is_expected.to eq [:and, [:or, [:is, 'a', :present], [:is, 'b', :blank]], [:is, 'c', :present]] }
    end

    context do
      let(:str) { 'NOT a=1' }

      it { is_expected.to eq [:not, [:eq, 'a', '1']] }
    end

    context do
      let(:str) { 'NOT (a=1)' }

      it { is_expected.to eq [:not, [:eq, 'a', '1']] }
    end

    context do
      let(:str) { 'NOT a=1 OR b=2' }

      it { is_expected.to eq [:or, [:not, [:eq, 'a', '1']], [:eq, 'b', '2']] }
    end

    context do
      let(:str) { 'NOT (a=1 OR b=2)' }

      it { is_expected.to eq [:not, [:or, [:eq, 'a', '1'], [:eq, 'b', '2']]] }
    end

    context do
      let(:str) { 'NOT a=1 OR NOT b=2' }

      it { is_expected.to eq [:or, [:not, [:eq, 'a', '1']], [:not, [:eq, 'b', '2']]] }
    end

    context do
      let(:str) { 'NOT a=1 AND b=2' }

      it { is_expected.to eq [:and, [:not, [:eq, 'a', '1']], [:eq, 'b', '2']] }
    end

    context do
      let(:str) { 'NOT (a=1 OR b=2)' }

      it { is_expected.to eq [:not, [:or, [:eq, 'a', '1'], [:eq, 'b', '2']]] }
    end

    context do
      let(:str) { 'NOT (NOT (a=1) OR b=2) AND NOT (c=3) OR d=4' }

      it {
        expect(subject).to eq [:or, [:and, [:not, [:or, [:not, [:eq, 'a', '1']], [:eq, 'b', '2']]], [:not, [:eq, 'c', '3']]],
                               [:eq, 'd', '4']]
      }
    end

    context do
      let(:str) { 'NOT env(a)=1' }

      it { is_expected.to eq [:not, [:eq, [:env, 'a'], '1']] }
    end

    context do
      let(:str) { 'NOT (env(a)=1)' }

      it { is_expected.to eq [:not, [:eq, [:env, 'a'], '1']] }
    end

    context do
      let(:str) { 'NOT (env(a)=1 OR env(b)=2)' }

      it { is_expected.to eq [:not, [:or, [:eq, [:env, 'a'], '1'], [:eq, [:env, 'b'], '2']]] }
    end
  end

  describe 'parse error' do
    let(:str) { 'wat.kaputt' }

    it { expect { subject }.to raise_error(Travis::Conditions::ParseError) }
  end
end
