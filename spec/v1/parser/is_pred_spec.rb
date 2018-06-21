describe Travis::Conditions::V1::Parser, 'is_pred' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).is_pred(:type) }

  it 'is  present' do
    should eq [:is, :type, :present]
  end

  it 'is present' do
    should eq [:is, :type, :present]
  end

  it 'IS present' do
    should eq [:is, :type, :present]
  end

  it 'is blank' do
    should eq [:is, :type, :blank]
  end

  it 'IS blank' do
    should eq [:is, :type, :blank]
  end
end
