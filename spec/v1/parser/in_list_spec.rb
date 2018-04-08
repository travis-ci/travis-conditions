describe Travis::Conditions::V1::Parser, 'in_list' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).in_list('foo') }

  it 'in (foo)' do
    should eq [:in, 'foo', [[:val, 'foo']]]
  end

  it 'in (type)' do
    should eq [:in, 'foo', [[:var, 'type']]]
  end

  it 'in (env(foo))' do
    should eq [:in, 'foo', [[:call, :env, [[:val, 'foo']]]]]
  end

  it 'in (env(env(foo)))' do
    should eq [:in, 'foo', [[:call, :env, [[:call, :env, [[:val, 'foo']]]]]]]
  end

  it 'in ( foo,bar)' do
    should eq [:in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'in (foo, bar )' do
    should eq [:in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'in (foo ,bar)' do
    should eq [:in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'in ("foo")' do
    should eq [:in, 'foo', [[:val, 'foo']]]
  end

  it 'not in (foo )' do
    should eq [:not_in, 'foo', [[:val, 'foo']]]
  end

  it 'not in ( foo,bar)' do
    should eq [:not_in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'not in (foo, bar )' do
    should eq [:not_in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'not in (foo ,bar)' do
    should eq [:not_in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'not in ("foo")' do
    should eq [:not_in, 'foo', [[:val, 'foo']]]
  end

  it 'in ()' do
    expect { subject }.to raise_error Travis::Conditions::V1::ParseError, 'expected a list of values at position 4 in: "in ()"'
  end
end
