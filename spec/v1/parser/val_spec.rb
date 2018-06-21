describe Travis::Conditions::V1::Parser, 'val' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).val }

  it 'foo' do
    should eq [:val, 'foo']
  end

  it '"foo"' do
    should eq [:val, 'foo']
  end

  it "'foo'" do
    should eq [:val, 'foo']
  end

  it 'typescript' do
    should eq [:val, 'typescript']
  end

  it 'sender-foo' do
    should eq [:val, 'sender-foo']
  end
end
