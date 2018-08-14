describe Travis::Conditions::V1::Parser, 'regex' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).parse }

  it 'branch =~ ^.*-foo$' do
    should eq [:match, [:var, :branch], [:reg, '^.*-foo$']]
  end

  it 'branch =~ /^.* foo$/' do
    should eq [:match, [:var, :branch], [:reg, '^.* foo$']]
  end

  it 'branch =~ /foo/ OR tag =~ /^foo$/' do
    should eq [:or,
      [:match, [:var, :branch], [:reg, 'foo']],
      [:match, [:var, :tag], [:reg, '^foo$']]
    ]
  end

  it 'branch =~ /foo/ OR (tag =~ /^foo$/)' do
    should eq [:or,
      [:match, [:var, :branch], [:reg, 'foo']],
      [:match, [:var, :tag], [:reg, '^foo$']]
    ]
  end
end

describe Travis::Conditions::V1::Regex do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).scan }

  it '^.*-foo$' do
    should eq '^.*-foo$'
  end

  it '/^.* foo$/' do
    should eq '/^.* foo$/'
  end

  it '/^(develop|master|release\/.*)$/' do
    should eq '/^(develop|master|release\/.*)$/'
  end

  it '/^(develop|master|release\/.*|feature\/.*)$/' do
    should eq '/^(develop|master|release\/.*|feature\/.*)$/'
  end
end
