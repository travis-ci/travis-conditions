describe Travis::Conditions::V1::Parser, 'term' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).term }

  it 'type = "foo"' do
    expect(subject).to eq [:eq, %i[var type], [:val, 'foo']]
  end

  it '"foo" = type' do
    expect(subject).to eq [:eq, [:val, 'foo'], %i[var type]]
  end

  it 'type = env(foo)' do
    expect(subject).to eq [:eq, %i[var type], [:call, :env, [[:val, 'foo']]]]
  end

  it 'env(foo) = type' do
    expect(subject).to eq [:eq, [:call, :env, [[:val, 'foo']]], %i[var type]]
  end

  it '"foo" = env(foo)' do
    expect(subject).to eq [:eq, [:val, 'foo'], [:call, :env, [[:val, 'foo']]]]
  end

  it 'env(foo) = "foo"' do
    expect(subject).to eq [:eq, [:call, :env, [[:val, 'foo']]], [:val, 'foo']]
  end

  it 'type = type' do
    expect(subject).to eq [:eq, %i[var type], %i[var type]]
  end

  it '"foo" = "foo"' do
    expect(subject).to eq [:eq, [:val, 'foo'], [:val, 'foo']]
  end

  it 'env(foo) = env(bar)' do
    expect(subject).to eq [:eq, [:call, :env, [[:val, 'foo']]], [:call, :env, [[:val, 'bar']]]]
  end

  it 'tag =~ foo' do
    expect(subject).to eq [:match, %i[var tag], [:reg, 'foo']]
  end

  it 'tag =~ /foo/' do
    expect(subject).to eq [:match, %i[var tag], [:reg, 'foo']]
  end

  it 'tag =~ env(foo)' do
    expect(subject).to eq [:match, %i[var tag], [:reg, [:call, :env, [[:val, 'foo']]]]]
  end

  it 'tag =~ concat(^foo-, env(foo))' do
    expect(subject).to eq [:match, %i[var tag],
                           [:reg, [:call, :concat, [[:val, '^foo-'], [:call, :env, [[:val, 'foo']]]]]]]
  end

  it 'type IN (foo)' do
    expect(subject).to eq [:in, %i[var type], [[:val, 'foo']]]
  end

  it '"foo" IN (foo)' do
    expect(subject).to eq [:in, [:val, 'foo'], [[:val, 'foo']]]
  end

  it 'env(foo) IN (foo)' do
    expect(subject).to eq [:in, [:call, :env, [[:val, 'foo']]], [[:val, 'foo']]]
  end

  it 'type IS present' do
    expect(subject).to eq [:is, %i[var type], :present]
  end

  it '"foo" IS present' do
    expect(subject).to eq [:is, [:val, 'foo'], :present]
  end

  it 'env(foo) IS present' do
    expect(subject).to eq [:is, [:call, :env, [[:val, 'foo']]], :present]
  end

  it 'sender = sender-foo' do
    expect(subject).to eq [:eq, %i[var sender], [:val, 'sender-foo']]
  end
end
