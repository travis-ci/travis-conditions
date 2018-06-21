describe Travis::Conditions::V1::Parser, 'quoted' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).quoted }

  it "'foo'" do
    should eq 'foo'
  end

  it '"foo"' do
    should eq 'foo'
  end

  it "'\"foo\"'" do
    should eq '"foo"'
  end

  it '"\'foo\'"' do
    should eq "'foo'"
  end

  it '"&.foo bar!?"' do
    should eq '&.foo bar!?'
  end
end
