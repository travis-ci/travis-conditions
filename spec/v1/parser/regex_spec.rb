describe Travis::Conditions::V1::Parser, 'regex' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).parse }

  it 'branch =~ ^.*-foo$' do
    expect(subject).to eq [:match, %i[var branch], [:reg, '^.*-foo$']]
  end

  it 'branch =~ /^.* foo$/' do
    expect(subject).to eq [:match, %i[var branch], [:reg, '^.* foo$']]
  end

  it 'branch =~ /foo/ OR tag =~ /^foo$/' do
    expect(subject).to eq [:or,
                           [:match, %i[var branch], [:reg, 'foo']],
                           [:match, %i[var tag], [:reg, '^foo$']]]
  end

  it 'branch =~ /foo/ OR (tag =~ /^foo$/)' do
    expect(subject).to eq [:or,
                           [:match, %i[var branch], [:reg, 'foo']],
                           [:match, %i[var tag], [:reg, '^foo$']]]
  end
end

describe Travis::Conditions::V1::Regex do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).scan }

  it '^.*-foo$' do
    expect(subject).to eq '^.*-foo$'
  end

  it '/^.* foo$/' do
    expect(subject).to eq '/^.* foo$/'
  end

  it '/^(develop|master|release\/.*)$/' do
    expect(subject).to eq '/^(develop|master|release\/.*)$/'
  end

  it '/^(develop|master|release\/.*|feature\/.*)$/' do
    expect(subject).to eq '/^(develop|master|release\/.*|feature\/.*)$/'
  end
end
