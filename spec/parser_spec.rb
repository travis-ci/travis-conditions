describe Travis::Conditions do
  subject { described_class.parse(str) }

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
    context do
      let(:str) { 'a=1 OR b=2 AND c=3 OR d=4' }
      it { should eq [:or, [:eq, 'a', '1'], [:or, [:and, [:eq, 'b', '2'], [:eq, 'c', '3']], [:eq, 'd', '4']]] }
    end

    context do
      let(:str) { '(a=1 OR b=2) AND (c=3 OR d=4)' }
      it { should eq [:and, [:or, [:eq, 'a', '1'], [:eq, 'b', '2']], [:or, [:eq, 'c', '3'], [:eq, 'd', '4']]] }
    end

    context do
      let(:str) { '(env(a)=1 OR env(b)=2) AND c=3' }
      it { should eq [:and, [:or, [:eq, [:env, 'a'], '1'], [:eq, [:env, 'b'], '2']], [:eq, 'c', '3']] }
    end
  end
end
