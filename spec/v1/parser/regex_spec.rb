describe Travis::Conditions::V1::Parser, 'regex' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).regex }

  it '^.*-bar$' do
    should eq [:reg, '^.*-bar$']
  end

  it '/^.* bar$/' do
    should eq [:reg, '^.* bar$']
  end
end
