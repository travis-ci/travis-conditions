describe Travis::Conditions::V1::Parser, 'parens' do
  let(:str) { |e| e.description }

  let(:subject) do
    parser = described_class.new(str)
    parser.parens { parser.word }
  end

  it '(foo)' do
    should eq 'foo'
  end

  it '( foo)' do
    should eq 'foo'
  end

  it '(foo )' do
    should eq 'foo'
  end

  it '( foo )' do
    should eq 'foo'
  end

  it 'foo' do
    should eq nil
  end
end
