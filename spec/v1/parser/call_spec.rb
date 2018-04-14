describe Travis::Conditions::V1::Parser, 'call' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).call }

  it 'env()' do
    should eq [:call, :env, []]
  end

  it 'env(foo)' do
    should eq [:call, :env, [[:val, 'foo']]]
  end

  it 'env(type)' do
    should eq [:call, :env, [[:var, :type]]]
  end

  it 'env(env(foo))' do
    should eq [:call, :env, [[:call, :env, [[:val, 'foo']]]]]
  end

  it 'env(env(env(foo)))' do
    should eq [:call, :env, [[:call, :env, [[:call, :env, [[:val, 'foo']]]]]]]
  end

  it 'env(foo, bar)' do
    should eq [:call, :env, [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'env("foo")' do
    should eq [:call, :env, [[:val, 'foo']]]
  end

  it 'env("foo", "bar")' do
    should eq [:call, :env, [[:val, 'foo'], [:val, 'bar']]]
  end

  it "env('foo')" do
    should eq [:call, :env, [[:val, 'foo']]]
  end

  it "env('foo', 'bar')" do
    should eq [:call, :env, [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'bar()' do
    should be_nil
  end
end
