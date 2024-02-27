describe Travis::Conditions::V1::Parser do
  let(:str)     { |e| e.description }
  let(:subject) { described_class.new(str).parse }

  # single term

  it '1' do
    expect(subject).to eq \
      [:val, '1']
  end

  it 'true' do
    expect(subject).to eq \
      [:val, 'true']
  end

  it 'type' do
    expect(subject).to eq \
      %i[var type]
  end

  it 'env(FOO)' do
    expect(subject).to eq \
      [:call, :env, [[:val, 'FOO']]]
  end

  it 'env()' do
    expect(subject).to eq \
      [:call, :env, []]
  end

  # one operand

  it '1=1' do
    expect(subject).to eq \
      [:eq, [:val, '1'], [:val, '1']]
  end

  it 'true=true' do
    expect(subject).to eq \
      [:eq, [:val, 'true'], [:val, 'true']]
  end

  it 'true!=false' do
    expect(subject).to eq \
      [:not_eq, [:val, 'true'], [:val, 'false']]
  end

  it '1 = 1' do
    expect(subject).to eq \
      [:eq, [:val, '1'], [:val, '1']]
  end

  it 'true = true' do
    expect(subject).to eq \
      [:eq, [:val, 'true'], [:val, 'true']]
  end

  it 'type = foo' do
    expect(subject).to eq \
      [:eq, %i[var type], [:val, 'foo']]
  end

  it '(type = foo)' do
    expect(subject).to eq \
      [:eq, %i[var type], [:val, 'foo']]
  end

  # two operands

  it 'type = foo OR type = bar' do
    expect(subject).to eq \
      [:or,
       [:eq, %i[var type], [:val, 'foo']],
       [:eq, %i[var type], [:val, 'bar']]]
  end

  it '(type = foo OR type = bar)' do
    expect(subject).to eq \
      [:or,
       [:eq, %i[var type], [:val, 'foo']],
       [:eq, %i[var type], [:val, 'bar']]]
  end

  # three operands

  it 'type = foo OR type = bar OR type = baz' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it 'type = foo AND type = bar OR type = baz' do
    expect(subject).to eq \
      [:or,
       [:and,
        [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it 'type = foo OR type = bar AND type = baz' do
    expect(subject).to eq \
      [:or,
       [:eq, %i[var type], [:val, 'foo']],
       [:and,
        [:eq, %i[var type], [:val, 'bar']],
        [:eq, %i[var type], [:val, 'baz']]]]
  end

  it 'type = foo AND type = bar AND type = baz' do
    expect(subject).to eq \
      [:and,
       [:and,
        [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it '(type = foo OR type = bar OR type = baz)' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it '(type = foo OR type = bar) AND type = baz' do
    expect(subject).to eq \
      [:and,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it 'type = foo AND (type = bar OR type = baz)' do
    expect(subject).to eq \
      [:and,
       [:eq, %i[var type], [:val, 'foo']],
       [:or,
        [:eq, %i[var type], [:val, 'bar']],
        [:eq, %i[var type], [:val, 'baz']]]]
  end

  # four operands

  it '(type = foo OR type = bar) AND (type = baz OR type = buz)' do
    expect(subject).to eq \
      [:and,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]],
       [:or,
        [:eq, %i[var type], [:val, 'baz']],
        [:eq, %i[var type], [:val, 'buz']]]]
  end

  it 'type = foo AND (type = bar OR type = baz) AND type = buz' do
    expect(subject).to eq \
      [:and,
       [:and,
        [:eq, %i[var type], [:val, 'foo']],
        [:or,
         [:eq, %i[var type], [:val, 'bar']],
         [:eq, %i[var type], [:val, 'baz']]]],
       [:eq, %i[var type], [:val, 'buz']]]
  end

  it 'type = foo AND (type = bar OR type = baz OR type = buz)' do
    expect(subject).to eq \
      [:and,
       [:eq, %i[var type], [:val, 'foo']],
       [:or,
        [:or,
         [:eq, %i[var type], [:val, 'bar']],
         [:eq, %i[var type], [:val, 'baz']]],
        [:eq, %i[var type], [:val, 'buz']]]]
  end

  it '(type = foo AND (type = bar OR type = baz)) OR type = buz' do
    expect(subject).to eq \
      [:or,
       [:and,
        [:eq, %i[var type], [:val, 'foo']],
        [:or,
         [:eq, %i[var type], [:val, 'bar']],
         [:eq, %i[var type], [:val, 'baz']]]],
       [:eq, %i[var type], [:val, 'buz']]]
  end

  # one operand negated

  it 'NOT type = foo' do
    expect(subject).to eq \
      [:not, [:eq, %i[var type], [:val, 'foo']]]
  end

  # two operands negated

  it 'NOT type = foo OR type = bar' do
    expect(subject).to eq \
      [:or,
       [:not, [:eq, %i[var type], [:val, 'foo']]],
       [:eq, %i[var type], [:val, 'bar']]]
  end

  it 'type = foo OR NOT type = bar' do
    expect(subject).to eq \
      [:or,
       [:eq, %i[var type], [:val, 'foo']],
       [:not, [:eq, %i[var type], [:val, 'bar']]]]
  end

  it 'NOT type = foo OR NOT type = bar' do
    expect(subject).to eq \
      [:or,
       [:not, [:eq, %i[var type], [:val, 'foo']]],
       [:not, [:eq, %i[var type], [:val, 'bar']]]]
  end

  it 'NOT (type = foo OR type = bar)' do
    expect(subject).to eq \
      [:not,
       [:or, [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]]]
  end

  # three operands negated

  it 'NOT type = foo OR type = bar OR type = baz' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:eq, %i[var type], [:val, 'bar']]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it '(NOT type = foo OR type = bar OR type = baz)' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:eq, %i[var type], [:val, 'bar']]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it 'type = foo OR NOT type = bar OR type = baz' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it '(type = foo OR NOT type = bar OR type = baz)' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it 'type = foo OR type = bar OR NOT type = baz' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it '(type = foo OR type = bar OR NOT type = baz)' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it 'NOT type = foo OR NOT type = bar OR type = baz' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it '(NOT type = foo OR NOT type = bar OR type = baz)' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it 'NOT type = foo OR type = bar OR NOT type = baz' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:eq, %i[var type], [:val, 'bar']]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it '(NOT type = foo OR type = bar OR NOT type = baz)' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:eq, %i[var type], [:val, 'bar']]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it 'type = foo OR NOT type = bar OR NOT type = baz' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it '(type = foo OR NOT type = bar OR NOT type = baz)' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it 'NOT type = foo OR NOT type = bar OR NOT type = baz' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it '(NOT type = foo OR NOT type = bar OR NOT type = baz)' do
    expect(subject).to eq \
      [:or,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it 'NOT (type = foo OR type = bar OR type = baz)' do
    expect(subject).to eq \
      [:not,
       [:or,
        [:or,
         [:eq, %i[var type], [:val, 'foo']],
         [:eq, %i[var type], [:val, 'bar']]],
        [:eq, %i[var type], [:val, 'baz']]]]
  end

  it 'NOT (type = foo OR type = bar) AND type = baz' do
    expect(subject).to eq \
      [:and,
       [:not,
        [:or,
         [:eq, %i[var type], [:val, 'foo']],
         [:eq, %i[var type], [:val, 'bar']]]],
       [:eq, %i[var type], [:val, 'baz']]]
  end

  it '(type = foo OR type = bar) AND NOT type = baz' do
    expect(subject).to eq \
      [:and,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:eq, %i[var type], [:val, 'bar']]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it 'NOT (type = foo OR type = bar) AND NOT type = baz' do
    expect(subject).to eq \
      [:and,
       [:not,
        [:or,
         [:eq, %i[var type], [:val, 'foo']],
         [:eq, %i[var type], [:val, 'bar']]]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it '(NOT type = foo OR type = bar) AND NOT type = baz' do
    expect(subject).to eq \
      [:and,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:eq, %i[var type], [:val, 'bar']]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  it '(type = foo OR NOT type = bar) AND NOT type = baz' do
    expect(subject).to eq \
      [:and,
       [:or,
        [:eq, %i[var type], [:val, 'foo']],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:not, [:eq, %i[var type], [:val, 'baz']]]]
  end

  # four operands negated

  it 'NOT (type = foo OR type = bar) AND NOT (type = baz OR type = buz)' do
    expect(subject).to eq \
      [:and,
       [:not,
        [:or,
         [:eq, %i[var type], [:val, 'foo']],
         [:eq, %i[var type], [:val, 'bar']]]],
       [:not,
        [:or,
         [:eq, %i[var type], [:val, 'baz']],
         [:eq, %i[var type], [:val, 'buz']]]]]
  end

  it '(NOT type = foo OR NOT type = bar) AND (NOT type = baz OR NOT type = buz)' do
    expect(subject).to eq \
      [:and,
       [:or,
        [:not, [:eq, %i[var type], [:val, 'foo']]],
        [:not, [:eq, %i[var type], [:val, 'bar']]]],
       [:or,
        [:not, [:eq, %i[var type], [:val, 'baz']]],
        [:not, [:eq, %i[var type], [:val, 'buz']]]]]
  end

  it 'NOT type = foo AND NOT (type = bar OR type = baz) AND NOT type = buz' do
    expect(subject).to eq \
      [:and,
       [:and,
        [:not,
         [:eq, %i[var type], [:val, 'foo']]],
        [:not,
         [:or,
          [:eq, %i[var type], [:val, 'bar']],
          [:eq, %i[var type], [:val, 'baz']]]]],
       [:not, [:eq, %i[var type], [:val, 'buz']]]]
  end

  it 'NOT type = foo AND (NOT type = bar OR NOT type = baz) AND NOT type = buz' do
    expect(subject).to eq \
      [:and,
       [:and,
        [:not,
         [:eq, %i[var type], [:val, 'foo']]],
        [:or,
         [:not, [:eq, %i[var type], [:val, 'bar']]],
         [:not, [:eq, %i[var type], [:val, 'baz']]]]],
       [:not, [:eq, %i[var type], [:val, 'buz']]]]
  end

  it 'NOT (NOT type = foo AND NOT (NOT type = bar OR NOT type = baz)) OR NOT type = buz' do
    expect(subject).to eq \
      [:or,
       [:not,
        [:and,
         [:not,
          [:eq, %i[var type], [:val, 'foo']]],
         [:not,
          [:or,
           [:not, [:eq, %i[var type], [:val, 'bar']]],
           [:not, [:eq, %i[var type], [:val, 'baz']]]]]]],
       [:not,
        [:eq, %i[var type], [:val, 'buz']]]]
  end

  it '= foo' do
    expect { subject }.to raise_error(Travis::Conditions::ParseError)
  end

  it 'branch = $FOO' do
    expect { subject }.to raise_error(Travis::Conditions::ParseError)
  end

  it '$FOO = bar' do
    expect { subject }.to raise_error(Travis::Conditions::ParseError)
  end

  describe 'given an array of strings' do
    let(:str) { %w[foo bar] }

    it { expect { subject }.to raise_error(Travis::Conditions::ArgumentError, 'Invalid condition: ["foo", "bar"]') }
  end
end
