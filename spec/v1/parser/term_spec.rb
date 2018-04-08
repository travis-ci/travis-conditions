describe Travis::Conditions::V1::Parser, 'term' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).term }

  it 'type = "foo"' do
    should eq [:eq, [:var, 'type'], [:val, 'foo']]
  end

  it '"foo" = type' do
    should eq [:eq, [:val, 'foo'], [:var, 'type']]
  end

  it 'type = env(foo)' do
    should eq [:eq, [:var, 'type'], [:call, :env, [[:val, 'foo']]]]
  end

  it 'env(foo) = type' do
    should eq [:eq, [:call, :env, [[:val, 'foo']]], [:var, 'type']]
  end

  it '"foo" = env(foo)' do
    should eq [:eq, [:val, 'foo'], [:call, :env, [[:val, 'foo']]]]
  end

  it 'env(foo) = "foo"' do
    should eq [:eq, [:call, :env, [[:val, 'foo']]], [:val, 'foo']]
  end

  it 'type = type' do
    should eq [:eq, [:var, 'type'], [:var, 'type']]
  end

  it '"foo" = "foo"' do
    should eq [:eq, [:val, 'foo'], [:val, 'foo']]
  end

  it 'env(foo) = env(bar)' do
    should eq [:eq, [:call, :env, [[:val, 'foo']]], [:call, :env, [[:val, 'bar']]]]
  end

  it 'type IN (foo)' do
    should eq [:in, [:var, 'type'], [[:val, 'foo']]]
  end

  it '"foo" IN (foo)' do
    should eq [:in, [:val, 'foo'], [[:val, 'foo']]]
  end

  it 'env(foo) IN (foo)' do
    should eq [:in, [:call, :env, [[:val, 'foo']]], [[:val, 'foo']]]
  end

  it 'type IS present' do
    should eq [:is, [:var, 'type'], :present]
  end

  it '"foo" IS present' do
    should eq [:is, [:val, 'foo'], :present]
  end

  it 'env(foo) IS present' do
    should eq [:is, [:call, :env, [[:val, 'foo']]], :present]
  end
end
