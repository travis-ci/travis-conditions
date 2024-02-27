describe Travis::Conditions::V1::Parser, 'space' do
  let(:str) { |e| e.description }

  let(:subject) do
    parser = described_class.new(str)
    parser.space { parser.word }
  end

  it 'foo' do
    expect(subject).to eq 'foo'
  end

  it 'foo' do
    expect(subject).to eq 'foo'
  end

  it 'foo' do
    expect(subject).to eq 'foo'
  end

  it 'foo' do
    expect(subject).to eq 'foo'
  end

  it "foo\t" do
    expect(subject).to eq 'foo'
  end

  it "\tfoo" do
    expect(subject).to eq 'foo'
  end

  it "foo\n" do
    expect(subject).to eq 'foo'
  end

  it "\nfoo" do
    expect(subject).to eq 'foo'
  end
end
