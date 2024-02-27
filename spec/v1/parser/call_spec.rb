describe Travis::Conditions::V1::Parser, 'call' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).call }

  it 'env()' do
    expect(subject).to eq [:call, :env, []]
  end

  it 'env(foo)' do
    expect(subject).to eq [:call, :env, [[:val, 'foo']]]
  end

  it 'env(type)' do
    expect(subject).to eq [:call, :env, [%i[var type]]]
  end

  it 'env(env(foo))' do
    expect(subject).to eq [:call, :env, [[:call, :env, [[:val, 'foo']]]]]
  end

  it 'env(env(env(foo)))' do
    expect(subject).to eq [:call, :env, [[:call, :env, [[:call, :env, [[:val, 'foo']]]]]]]
  end

  it 'env(foo, bar)' do
    expect(subject).to eq [:call, :env, [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'env("foo")' do
    expect(subject).to eq [:call, :env, [[:val, 'foo']]]
  end

  it 'env("foo", "bar")' do
    expect(subject).to eq [:call, :env, [[:val, 'foo'], [:val, 'bar']]]
  end

  it "env('foo')" do
    expect(subject).to eq [:call, :env, [[:val, 'foo']]]
  end

  it "env('foo', 'bar')" do
    expect(subject).to eq [:call, :env, [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'concat()' do
    expect(subject).to eq [:call, :concat, []]
  end

  it 'concat(foo)' do
    expect(subject).to eq [:call, :concat, [[:val, 'foo']]]
  end

  it 'concat(foo, bar)' do
    expect(subject).to eq [:call, :concat, [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'concat(foo, env(bar))' do
    expect(subject).to eq [:call, :concat, [[:val, 'foo'], [:call, :env, [[:val, 'bar']]]]]
  end

  it 'concat(branch, foo)' do
    expect(subject).to eq [:call, :concat, [%i[var branch], [:val, 'foo']]]
  end

  it 'bar()' do
    expect(subject).to be_nil
  end
end
