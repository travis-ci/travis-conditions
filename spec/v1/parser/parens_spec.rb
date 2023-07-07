describe Travis::Conditions::V1::Parser, 'parens' do
  let(:str) { |e| e.description }

  let(:subject) do
    parser = described_class.new(str)
    parser.parens { parser.word }
  end

  it '(foo)' do
    expect(subject).to eq 'foo'
  end

  it '( foo)' do
    expect(subject).to eq 'foo'
  end

  it '(foo )' do
    expect(subject).to eq 'foo'
  end

  it '( foo )' do
    expect(subject).to eq 'foo'
  end

  it 'foo' do
    expect(subject).to eq nil
  end
end
