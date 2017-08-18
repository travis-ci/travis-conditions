describe Travis::Conditions do
  let(:keys) { [:foo] }
  subject { described_class.parse(str, keys: keys) }

  describe 'eq' do
    context do
      let(:str) { 'foo = bar' }
      it { should eq [:eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo =bar' }
      it { should eq [:eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo= bar' }
      it { should eq [:eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo=bar' }
      it { should eq [:eq, 'foo', 'bar'] }
    end

    context do
      let(:str) { 'foo = "bar baz"' }
      it { should eq [:eq, 'foo', 'bar baz'] }
    end

    context do
      let(:str) { 'foo="bar baz"' }
      it { should eq [:eq, 'foo', 'bar baz'] }
    end

    context do
      let(:str) { 'env(foo) = "bar baz"' }
      it { should eq [:eq, [:env, 'foo'], 'bar baz'] }
    end
  end

  describe 'match' do
    context do
      let(:str) { 'foo =~ ^v[0-9]$' }
      it { should eq [:match, 'foo', '^v[0-9]$'] }
    end

    context do
      let(:str) { 'env(foo) =~ ^v[0-9]$' }
      it { should eq [:match, [:env, 'foo'], '^v[0-9]$'] }
    end
  end

  describe 'in' do
    context do
      let(:str) { 'foo IN (bar)' }
      it { should eq [:in, 'foo', ['bar']] }
    end

    context do
      let(:str) { 'foo IN (bar, baz, buz)' }
      it { should eq [:in, 'foo', ['bar', 'baz', 'buz']] }
    end

    context do
      let(:str) { 'foo IN (bar, "baz, buz")' }
      it { should eq [:in, 'foo', ['bar', 'baz, buz']] }
    end

    context do
      let(:str) { 'env(foo) IN (bar, "baz, buz")' }
      it { should eq [:in, [:env, 'foo'], ['bar', 'baz, buz']] }
    end
  end

  describe 'is' do
    context do
      let(:str) { 'foo IS present' }
      it { should eq [:is, 'foo', :present] }
    end

    context do
      let(:str) { 'foo IS PRESENT' }
      it { should eq [:is, 'foo', :present] }
    end

    context do
      let(:str) { 'foo IS blank' }
      it { should eq [:is, 'foo', :blank] }
    end

    context do
      let(:str) { 'foo IS BLANK' }
      it { should eq [:is, 'foo', :blank] }
    end

    context do
      let(:str) { 'env(foo) IS BLANK' }
      it { should eq [:is, [:env, 'foo'], :blank] }
    end
  end

  describe 'boolean' do
    let(:keys) { [:a, :b, :c, :d] }

    context do
      let(:str) { 'a=1 OR b=2 AND c=3 OR d=4' }
      it { should eq [:or, [:eq, 'a', '1'], [:or, [:and, [:eq, 'b', '2'], [:eq, 'c', '3']], [:eq, 'd', '4']]] }
    end

    context do
      let(:str) { '(a=1) OR (b=2) AND (c=3) OR (d=4)' }
      it { should eq [:or, [:eq, 'a', '1'], [:or, [:and, [:eq, 'b', '2'], [:eq, 'c', '3']], [:eq, 'd', '4']]] }
    end

    context do
      let(:str) { '(a=1 OR b=2) AND (c=3 OR d=4)' }
      it { should eq [:and, [:or, [:eq, 'a', '1'], [:eq, 'b', '2']], [:or, [:eq, 'c', '3'], [:eq, 'd', '4']]] }
    end

    context do
      let(:str) { 'env(a)=1 OR env(b)=2 AND c=3' }
      it { should eq [:or, [:eq, [:env, 'a'], '1'], [:and, [:eq, [:env, 'b'], '2'], [:eq, 'c', '3']]] }
    end

    context do
      let(:str) { '(env(a)=1) OR (env(b)=2) AND (c=3)' }
      it { should eq [:or, [:eq, [:env, 'a'], '1'], [:and, [:eq, [:env, 'b'], '2'], [:eq, 'c', '3']]] }
    end

    context do
      let(:str) { '(env(a)=1 OR env(b)=2) AND c=3' }
      it { should eq [:and, [:or, [:eq, [:env, 'a'], '1'], [:eq, [:env, 'b'], '2']], [:eq, 'c', '3']] }
    end

    context do
      let(:str) { 'a IN (1) OR b IN (2) AND c IN (3)' }
      it { should eq [:or, [:in, 'a', ['1']], [:and, [:in, 'b', ['2']], [:in, 'c', ['3']]]] }
    end

    context do
      let(:str) { '(a IN (1) OR b IN (2)) AND (c IN (3))' }
      it { should eq [:and, [:or, [:in, 'a', ['1']], [:in, 'b', ['2']]], [:in, 'c', ['3']]] }
    end

    context do
      let(:str) { 'a IS present OR b IS blank AND c IS present' }
      it { should eq [:or, [:is, 'a', :present], [:and, [:is, 'b', :blank], [:is, 'c', :present]]] }
    end

    context do
      let(:str) { '(a IS present OR (b IS blank)) AND (c IS present)' }
      it { should eq [:and, [:or, [:is, 'a', :present], [:is, 'b', :blank]], [:is, 'c', :present]] }
    end

    context do
      let(:str) { 'NOT a=1' }
      it { should eq [:not, [:eq, 'a', '1']] }
    end

    context do
      let(:str) { 'NOT (a=1)' }
      it { should eq [:not, [:eq, 'a', '1']] }
    end

    context do
      let(:str) { 'NOT a=1 OR b=2' }
      it { should eq [:or, [:not, [:eq, 'a', '1']], [:eq, 'b', '2']] }
    end

    context do
      let(:str) { 'NOT (a=1 OR b=2)' }
      it { should eq [:not, [:or, [:eq, 'a', '1'], [:eq, 'b', '2']]] }
    end

    context do
      let(:str) { 'NOT a=1 OR NOT b=2' }
      it { should eq [:or, [:not, [:eq, 'a', '1']], [:not, [:eq, 'b', '2']]] }
    end

    context do
      let(:str) { 'NOT a=1 AND b=2' }
      it { should eq [:and, [:not, [:eq, 'a', '1']], [:eq, 'b', '2']] }
    end

    context do
      let(:str) { 'NOT (a=1 OR b=2)' }
      it { should eq [:not, [:or, [:eq, 'a', '1'], [:eq, 'b', '2']]] }
    end

    context do
      let(:str) { 'NOT (NOT (a=1) OR b=2) AND NOT (c=3) OR d=4' }
      it { should eq [:or, [:and, [:not, [:or, [:not, [:eq, 'a', '1']], [:eq, 'b', '2']]], [:not, [:eq, 'c', '3']]], [:eq, 'd', '4']] }
    end

    context do
      let(:str) { 'NOT env(a)=1' }
      it { should eq [:not, [:eq, [:env, 'a'], '1']] }
    end

    context do
      let(:str) { 'NOT (env(a)=1)' }
      it { should eq [:not, [:eq, [:env, 'a'], '1']] }
    end

    context do
      let(:str) { 'NOT (env(a)=1 OR env(b)=2)' }
      it { should eq [:not, [:or, [:eq, [:env, 'a'], '1'],[:eq, [:env, 'b'], '2']]] }
    end
  end
end
