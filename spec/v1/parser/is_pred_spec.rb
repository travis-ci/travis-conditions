describe Travis::Conditions::V1::Parser, 'is_pred' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).is_pred(:type) }

  it 'is present' do
    expect(subject).to eq %i[is type present]
  end

  it 'is present' do
    expect(subject).to eq %i[is type present]
  end

  it 'IS present' do
    expect(subject).to eq %i[is type present]
  end

  it 'is blank' do
    expect(subject).to eq %i[is type blank]
  end

  it 'IS blank' do
    expect(subject).to eq %i[is type blank]
  end
end
