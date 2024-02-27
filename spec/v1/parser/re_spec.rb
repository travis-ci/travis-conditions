describe Travis::Conditions::V1::Parser, 'operand' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).operand }

  it 'type' do
    expect(subject).to eq %i[var type]
  end

  it 'foo' do
    expect(subject).to eq [:val, 'foo']
  end

  it 'env(foo)' do
    expect(subject).to eq [:call, :env, [[:val, 'foo']]]
  end
end
