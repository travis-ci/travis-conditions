describe Travis::Conditions::V1::Parser, 'eq' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).eq }

  it '=' do
    should eq :eq
  end

  it '==' do
    should eq :eq
  end

  it '!=' do
    should eq :not_eq
  end
end
