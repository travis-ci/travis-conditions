describe Travis::Conditions::V1::Parser, 'quoted' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).quoted }

  it "'foo'" do
    expect(subject).to eq 'foo'
  end

  it '"foo"' do
    expect(subject).to eq 'foo'
  end

  it "'\"foo\"'" do
    expect(subject).to eq '"foo"'
  end

  it '"\'foo\'"' do
    expect(subject).to eq "'foo'"
  end

  it '"&.foo bar!?"' do
    expect(subject).to eq '&.foo bar!?'
  end
end
