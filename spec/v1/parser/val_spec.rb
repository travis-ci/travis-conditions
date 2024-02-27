describe Travis::Conditions::V1::Parser, 'val' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).val }

  it 'foo' do
    expect(subject).to eq [:val, 'foo']
  end

  it '"foo"' do
    expect(subject).to eq [:val, 'foo']
  end

  it "'foo'" do
    expect(subject).to eq [:val, 'foo']
  end

  it 'typescript' do
    expect(subject).to eq [:val, 'typescript']
  end

  it 'sender-foo' do
    expect(subject).to eq [:val, 'sender-foo']
  end
end
