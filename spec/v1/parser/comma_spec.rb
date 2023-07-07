describe Travis::Conditions::V1::Parser, 'comma' do
  let(:str) { |e| e.description }

  let(:subject) do
    p = described_class.new(str)
    [p.word.tap { p.comma }, p.word]
  end

  it 'foo,bar' do
    expect(subject).to eq %w[foo bar]
  end

  it 'foo, bar' do
    expect(subject).to eq %w[foo bar]
  end

  it 'foo ,bar' do
    expect(subject).to eq %w[foo bar]
  end

  it 'foo , bar' do
    expect(subject).to eq %w[foo bar]
  end

  it 'foo' do
    expect(subject).to eq ['foo', nil]
  end
end
