describe Travis::EnvVars::String do
  subject { |e| described_class.new(e.description).parse }

  it %(FOO=) do
    should eq [%(FOO=)]
  end

  it %(FOO="") do
    should eq [%(FOO="")]
  end

  it %(FOO=foo BAR=bar BAZ=baz) do
    should eq [%(FOO=foo), %(BAR=bar), %(BAZ=baz)]
  end

  it %(FOO="foo foo" BAR="bar bar") do
    should eq [%(FOO="foo foo"), %(BAR="bar bar")]
  end

  it %(FOO='foo foo' BAR='bar bar') do
    should eq [%(FOO='foo foo'), %(BAR='bar bar')]
  end

  it %(FOO='"foo foo" foo' BAR='"bar bar" bar') do
    should eq [%(FOO='"foo foo" foo'), %(BAR='"bar bar" bar')]
  end

  it %(FOO="'foo foo' foo" BAR="'bar bar' bar") do
    should eq [%(FOO="'foo foo' foo"), %(BAR="'bar bar' bar")]
  end

  it 'FOO=foo\"bar' do
    should eq ['FOO=foo\"bar']
  end

  it 'FOO="\"foo\" bar"' do
    should eq ['FOO="\"foo\" bar"']
  end

  it 'FOO="\"\\\"foo foo\\\"\" foo"' do
    should eq ['FOO="\"\\\"foo foo\\\"\" foo"']
  end

  it 'FOO=$bar' do
    should eq ['FOO=$bar']
  end

  it 'FOO="$bar"' do
    should eq ['FOO="$bar"']
  end

  it 'FOO=$(pwd)' do
    should eq ['FOO=$(pwd)']
  end

  it 'FOO=`pwd`' do
    should eq ['FOO=`pwd`']
  end

  it 'FOO' do
    expect { subject }.to raise_error(described_class::ParseError)
  end

  it 'FOO="' do
    expect { subject }.to raise_error(described_class::ParseError)
  end

  xit 'FOO="\"' do
    expect { subject }.to raise_error(described_class::ParseError)
  end

  it 'FOO=foo"bar' do
    expect { subject }.to raise_error(described_class::ParseError)
  end
end
