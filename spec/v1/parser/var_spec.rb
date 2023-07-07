describe Travis::Conditions::V1::Parser, 'var' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).var }

  it 'type' do
    expect(subject).to eq %i[var type]
  end

  it 'repo' do
    expect(subject).to eq %i[var repo]
  end

  it 'nope' do
    expect(subject).to be_nil
  end
end
