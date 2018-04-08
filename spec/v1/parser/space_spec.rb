describe Travis::Conditions::V1::Parser, 'space' do
  let(:str) { |e| e.description }

  let(:subject) do
    parser = described_class.new(str)
    parser.space { parser.word }
  end

  it 'foo' do
    should eq 'foo'
  end

  it ' foo' do
    should eq 'foo'
  end

  it 'foo ' do
    should eq 'foo'
  end

  it '  foo  ' do
    should eq 'foo'
  end

  it "foo\t" do
    should eq 'foo'
  end

  it "\tfoo" do
    should eq 'foo'
  end

  it "foo\n" do
    should eq 'foo'
  end

  it "\nfoo" do
    should eq 'foo'
  end
end
