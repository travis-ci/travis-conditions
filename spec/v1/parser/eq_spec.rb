describe Travis::Conditions::V1::Parser, 'eq' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).eq }

  it '=' do
    expect(subject).to eq :eq
  end

  it '==' do
    expect(subject).to eq :eq
  end

  it '!=' do
    expect(subject).to eq :not_eq
  end
end
