class BooleanParser
  extend Forwardable
  include Travis::Conditions::V1::Boolean
  include Travis::Conditions::V1::Helper

  def_delegators :str, :scan, :skip, :string, :pos, :peek
  attr_reader :str

  VAR = /[A-Z]{1}/

  def initialize(str)
    @str = StringScanner.new(str)
  end

  def term
    space { scan(VAR) }
  end
end

describe BooleanParser, 'expr' do
  let(:str)     { |e| e.description }
  let(:subject) { described_class.new(str).expr }

  # one term

  it 'A' do
    expect(subject).to eq 'A'
  end

  it '(A)' do
    expect(subject).to eq 'A'
  end

  it 'not A' do
    expect(subject).to eq [:not, 'A']
  end

  it 'not (A)' do
    expect(subject).to eq [:not, 'A']
  end

  it '(not A)' do
    expect(subject).to eq [:not, 'A']
  end

  it '!A' do
    expect(subject).to eq [:not, 'A']
  end

  it '! A' do
    expect(subject).to eq [:not, 'A']
  end

  it '!(A)' do
    expect(subject).to eq [:not, 'A']
  end

  it '! (A)' do
    expect(subject).to eq [:not, 'A']
  end

  # two terms

  it 'A and B' do
    expect(subject).to eq [:and, 'A', 'B']
  end

  it '(A) and B' do
    expect(subject).to eq [:and, 'A', 'B']
  end

  it 'A and (B)' do
    expect(subject).to eq [:and, 'A', 'B']
  end

  it '(A) and (B)' do
    expect(subject).to eq [:and, 'A', 'B']
  end

  it 'not A and B' do
    expect(subject).to eq [:and, [:not, 'A'], 'B']
  end

  it 'A and not B' do
    expect(subject).to eq [:and, 'A', [:not, 'B']]
  end

  it 'not A and not B' do
    expect(subject).to eq [:and, [:not, 'A'], [:not, 'B']]
  end

  it 'not (A) and B' do
    expect(subject).to eq [:and, [:not, 'A'], 'B']
  end

  it '(A) and not B' do
    expect(subject).to eq [:and, 'A', [:not, 'B']]
  end

  it 'not (A) and not B' do
    expect(subject).to eq [:and, [:not, 'A'], [:not, 'B']]
  end

  it 'not (A) and (B)' do
    expect(subject).to eq [:and, [:not, 'A'], 'B']
  end

  it '(A) and not (B)' do
    expect(subject).to eq [:and, 'A', [:not, 'B']]
  end

  it 'not (A) and not (B)' do
    expect(subject).to eq [:and, [:not, 'A'], [:not, 'B']]
  end

  it '(not A) and B' do
    expect(subject).to eq [:and, [:not, 'A'], 'B']
  end

  it '(A) and not B' do
    expect(subject).to eq [:and, 'A', [:not, 'B']]
  end

  it '(not A) and not B' do
    expect(subject).to eq [:and, [:not, 'A'], [:not, 'B']]
  end

  it '(not A) and (B)' do
    expect(subject).to eq [:and, [:not, 'A'], 'B']
  end

  it '(A) and (not B)' do
    expect(subject).to eq [:and, 'A', [:not, 'B']]
  end

  it '(not A) and (not B)' do
    expect(subject).to eq [:and, [:not, 'A'], [:not, 'B']]
  end

  it '(! A) && !B' do
    expect(subject).to eq [:and, [:not, 'A'], [:not, 'B']]
  end

  # three terms

  it 'A and B and C' do
    expect(subject).to eq [:and, [:and, 'A', 'B'], 'C']
  end

  it 'A and B or C' do
    expect(subject).to eq [:or, [:and, 'A', 'B'], 'C']
  end

  it 'A or B and C' do
    expect(subject).to eq [:or, 'A', [:and, 'B', 'C']]
  end

  it 'A or B or C' do
    expect(subject).to eq [:or, [:or, 'A', 'B'], 'C']
  end

  it '(A and B and C)' do
    expect(subject).to eq [:and, [:and, 'A', 'B'], 'C']
  end

  it '(A and B) and C' do
    expect(subject).to eq [:and, [:and, 'A', 'B'], 'C']
  end

  it 'A and (B and C)' do
    expect(subject).to eq [:and, 'A', [:and, 'B', 'C']]
  end

  it '(A or B) and C' do
    expect(subject).to eq [:and, [:or, 'A', 'B'], 'C']
  end

  it 'A and (B or C)' do
    expect(subject).to eq [:and, 'A', [:or, 'B', 'C']]
  end

  it '(not A and not B and not C)' do
    expect(subject).to eq [:and, [:and, [:not, 'A'], [:not, 'B']], [:not, 'C']]
  end

  it 'not (not A and not B and not C)' do
    expect(subject).to eq [:not, [:and, [:and, [:not, 'A'], [:not, 'B']], [:not, 'C']]]
  end

  it '(not A or not B) and not C' do
    expect(subject).to eq [:and, [:or, [:not, 'A'], [:not, 'B']], [:not, 'C']]
  end

  it 'not (not A or not B) and not C' do
    expect(subject).to eq [:and, [:not, [:or, [:not, 'A'], [:not, 'B']]], [:not, 'C']]
  end

  it 'not(not A and not (not B or not C))' do
    expect(subject).to eq [:not, [:and, [:not, 'A'], [:not, [:or, [:not, 'B'], [:not, 'C']]]]]
  end

  # six terms

  it 'A or B and C or D and E or F' do
    expect(subject).to eq [:or, [:or, [:or, 'A', [:and, 'B', 'C']], [:and, 'D', 'E']], 'F']
  end

  it '(A or B) and C or D and (E or F)' do
    expect(subject).to eq [:or, [:and, [:or, 'A', 'B'], 'C'], [:and, 'D', [:or, 'E', 'F']]]
  end

  it '(A or B) and (C or D) and (E or F)' do
    expect(subject).to eq [:and, [:and, [:or, 'A', 'B'], [:or, 'C', 'D']], [:or, 'E', 'F']]
  end
end
