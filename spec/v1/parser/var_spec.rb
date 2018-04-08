describe Travis::Conditions::V1::Parser, 'var' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).var }

  it 'type' do
    should eq [:var, 'type']
  end

  it 'repo' do
    should eq [:var, 'repo']
  end

  it 'nope' do
    should be_nil
  end
end
