describe Travis::Conditions::V1::Parser, 'in_list' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).in_list('foo') }

  it 'in (foo)' do
    expect(subject).to eq [:in, 'foo', [[:val, 'foo']]]
  end

  it 'in (type)' do
    expect(subject).to eq [:in, 'foo', [%i[var type]]]
  end

  it 'in (env(foo))' do
    expect(subject).to eq [:in, 'foo', [[:call, :env, [[:val, 'foo']]]]]
  end

  it 'in (env(env(foo)))' do
    expect(subject).to eq [:in, 'foo', [[:call, :env, [[:call, :env, [[:val, 'foo']]]]]]]
  end

  it 'in ( foo,bar)' do
    expect(subject).to eq [:in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'in (foo, bar )' do
    expect(subject).to eq [:in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'in (foo ,bar)' do
    expect(subject).to eq [:in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'in ("foo")' do
    expect(subject).to eq [:in, 'foo', [[:val, 'foo']]]
  end

  it 'not in (foo )' do
    expect(subject).to eq [:not_in, 'foo', [[:val, 'foo']]]
  end

  it 'not in ( foo,bar)' do
    expect(subject).to eq [:not_in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'not in (foo, bar )' do
    expect(subject).to eq [:not_in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'not in (foo ,bar)' do
    expect(subject).to eq [:not_in, 'foo', [[:val, 'foo'], [:val, 'bar']]]
  end

  it 'not in ("foo")' do
    expect(subject).to eq [:not_in, 'foo', [[:val, 'foo']]]
  end

  it 'in ()' do
    expect do
      subject
    end.to raise_error Travis::Conditions::ParseError, 'expected a list of values at position 4 in: "in ()"'
  end
end
