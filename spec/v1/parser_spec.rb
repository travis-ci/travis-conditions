describe Travis::Conditions::V1::Parser do
  let(:str)     { |e| e.description }
  let(:subject) { described_class.new(str).parse }

  # single term

  it '1' do
    should eq \
      [:val, '1']
  end

  it 'true' do
    should eq \
      [:val, 'true']
  end

  it 'type' do
    should eq \
      [:var, :type]
  end

  it 'env(FOO)' do
    should eq \
      [:call, :env, [[:val, 'FOO']]]
  end

  it 'env()' do
    should eq \
      [:call, :env, []]
  end

  # one operand

  it '1=1' do
    should eq \
      [:eq, [:val, '1'], [:val, '1']]
  end

  it 'true=true' do
    should eq \
      [:eq, [:val, 'true'], [:val, 'true']]
  end

  it 'true!=false' do
    should eq \
      [:not_eq, [:val, 'true'], [:val, 'false']]
  end

  it '1 = 1' do
    should eq \
      [:eq, [:val, '1'], [:val, '1']]
  end

  it 'true = true' do
    should eq \
      [:eq, [:val, 'true'], [:val, 'true']]
  end

  it 'type = foo' do
    should eq \
      [:eq, [:var, :type], [:val, 'foo']]
  end

  it '(type = foo)' do
    should eq \
      [:eq, [:var, :type], [:val, 'foo']]
  end

  # two operands

  it 'type = foo OR type = bar' do
    should eq \
      [:or,
        [:eq, [:var, :type], [:val, 'foo']],
        [:eq, [:var, :type], [:val, 'bar']]]
  end

  it '(type = foo OR type = bar)' do
    should eq \
      [:or,
        [:eq, [:var, :type], [:val, 'foo']],
        [:eq, [:var, :type], [:val, 'bar']]]
  end

  # three operands

  it 'type = foo OR type = bar OR type = baz' do
    should eq \
      [:or,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it 'type = foo AND type = bar OR type = baz' do
    should eq \
      [:or,
        [:and,
          [:eq, [:var, :type], [:val, 'foo']],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it 'type = foo OR type = bar AND type = baz' do
    should eq \
      [:or,
        [:eq, [:var, :type], [:val, 'foo']],
        [:and,
          [:eq, [:var, :type], [:val, 'bar']],
          [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it 'type = foo AND type = bar AND type = baz' do
    should eq \
      [:and,
        [:and,
          [:eq, [:var, :type], [:val, 'foo']],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it '(type = foo OR type = bar OR type = baz)' do
    should eq \
      [:or,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it '(type = foo OR type = bar) AND type = baz' do
    should eq \
      [:and,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it 'type = foo AND (type = bar OR type = baz)' do
    should eq \
      [:and,
        [:eq, [:var, :type], [:val, 'foo']],
        [:or,
          [:eq, [:var, :type], [:val, 'bar']],
          [:eq, [:var, :type], [:val, 'baz']]]]
  end

  # four operands

  it '(type = foo OR type = bar) AND (type = baz OR type = buz)' do
    should eq \
      [:and,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:or,
          [:eq, [:var, :type], [:val, 'baz']],
          [:eq, [:var, :type], [:val, 'buz']]]]
  end

  it 'type = foo AND (type = bar OR type = baz) AND type = buz' do
    should eq \
      [:and,
        [:and,
          [:eq, [:var, :type], [:val, 'foo']],
          [:or,
            [:eq, [:var, :type], [:val, 'bar']],
            [:eq, [:var, :type], [:val, 'baz']]]],
        [:eq, [:var, :type], [:val, 'buz']]]
  end

  it 'type = foo AND (type = bar OR type = baz OR type = buz)' do
    should eq \
      [:and,
        [:eq, [:var, :type], [:val, 'foo']],
        [:or,
          [:or,
            [:eq, [:var, :type], [:val, 'bar']],
            [:eq, [:var, :type], [:val, 'baz']]],
          [:eq, [:var, :type], [:val, 'buz']]]]
  end

  it '(type = foo AND (type = bar OR type = baz)) OR type = buz' do
    should eq \
      [:or,
        [:and,
          [:eq, [:var, :type], [:val, 'foo']],
          [:or,
            [:eq, [:var, :type], [:val, 'bar']],
            [:eq, [:var, :type], [:val, 'baz']]]],
        [:eq, [:var, :type], [:val, 'buz']]]
  end

  # one operand negated

  it 'NOT type = foo' do
    should eq \
      [:not, [:eq, [:var, :type], [:val, 'foo']]]
  end

  # two operands negated

  it 'NOT type = foo OR type = bar' do
    should eq \
      [:or,
        [:not, [:eq, [:var, :type], [:val, 'foo']]],
        [:eq, [:var, :type], [:val, 'bar']]]
  end

  it 'type = foo OR NOT type = bar' do
    should eq \
      [:or,
        [:eq, [:var, :type], [:val, 'foo']],
        [:not, [:eq, [:var, :type], [:val, 'bar']]]]
  end

  it 'NOT type = foo OR NOT type = bar' do
    should eq \
      [:or,
        [:not, [:eq, [:var, :type], [:val, 'foo']]],
        [:not, [:eq, [:var, :type], [:val, 'bar']]]]
  end

  it 'NOT (type = foo OR type = bar)' do
    should eq \
      [:not,
        [:or, [:eq, [:var, :type], [:val, 'foo']],
        [:eq, [:var, :type], [:val, 'bar']]]]
  end

  # three operands negated

  it 'NOT type = foo OR type = bar OR type = baz' do
    should eq \
      [:or,
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'foo']]],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it '(NOT type = foo OR type = bar OR type = baz)' do
    should eq \
      [:or,
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'foo']]],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it 'type = foo OR NOT type = bar OR type = baz' do
    should eq \
      [:or,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it '(type = foo OR NOT type = bar OR type = baz)' do
    should eq \
      [:or,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it 'type = foo OR type = bar OR NOT type = baz' do
    should eq \
      [:or,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it '(type = foo OR type = bar OR NOT type = baz)' do
    should eq \
      [:or,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it 'NOT type = foo OR NOT type = bar OR type = baz' do
    should eq \
      [:or,
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'foo']]],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it '(NOT type = foo OR NOT type = bar OR type = baz)' do
    should eq \
      [:or,
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'foo']]],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it 'NOT type = foo OR type = bar OR NOT type = baz' do
    should eq \
      [:or,
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'foo']]],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it '(NOT type = foo OR type = bar OR NOT type = baz)' do
    should eq \
      [:or,
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'foo']]],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it 'type = foo OR NOT type = bar OR NOT type = baz' do
    should eq \
      [:or,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it '(type = foo OR NOT type = bar OR NOT type = baz)' do
    should eq \
      [:or,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it 'NOT type = foo OR NOT type = bar OR NOT type = baz' do
    should eq \
      [:or,
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'foo']]],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it '(NOT type = foo OR NOT type = bar OR NOT type = baz)' do
    should eq \
      [:or,
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'foo']]],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
         [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it 'NOT (type = foo OR type = bar OR type = baz)' do
    should eq \
      [:not,
        [:or,
          [:or,
            [:eq, [:var, :type], [:val, 'foo']],
            [:eq, [:var, :type], [:val, 'bar']]],
          [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it 'NOT (type = foo OR type = bar) AND type = baz' do
    should eq \
      [:and,
        [:not,
          [:or,
            [:eq, [:var, :type], [:val, 'foo']],
            [:eq, [:var, :type], [:val, 'bar']]]],
        [:eq, [:var, :type], [:val, 'baz']]]
  end

  it '(type = foo OR type = bar) AND NOT type = baz' do
    should eq \
      [:and,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:eq, [:var, :type], [:val, 'bar']]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it 'NOT (type = foo OR type = bar) AND NOT type = baz' do
    should eq \
      [:and,
        [:not,
          [:or,
            [:eq, [:var, :type], [:val, 'foo']],
            [:eq, [:var, :type], [:val, 'bar']]]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it '(NOT type = foo OR type = bar) AND NOT type = baz' do
    should eq \
      [:and,
        [:or,
           [:not, [:eq, [:var, :type], [:val, 'foo']]],
           [:eq, [:var, :type], [:val, 'bar']]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  it '(type = foo OR NOT type = bar) AND NOT type = baz' do
    should eq \
      [:and,
        [:or,
          [:eq, [:var, :type], [:val, 'foo']],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
        [:not, [:eq, [:var, :type], [:val, 'baz']]]]
  end

  # four operands negated

  it 'NOT (type = foo OR type = bar) AND NOT (type = baz OR type = buz)' do
    should eq \
      [:and,
        [:not,
          [:or,
            [:eq, [:var, :type], [:val, 'foo']],
            [:eq, [:var, :type], [:val, 'bar']]]],
        [:not,
          [:or,
            [:eq, [:var, :type], [:val, 'baz']],
            [:eq, [:var, :type], [:val, 'buz']]]]]
  end

  it '(NOT type = foo OR NOT type = bar) AND (NOT type = baz OR NOT type = buz)' do
    should eq \
      [:and,
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'foo']]],
          [:not, [:eq, [:var, :type], [:val, 'bar']]]],
        [:or,
          [:not, [:eq, [:var, :type], [:val, 'baz']]],
          [:not, [:eq, [:var, :type], [:val, 'buz']]]]]
  end

  it 'NOT type = foo AND NOT (type = bar OR type = baz) AND NOT type = buz' do
    should eq \
      [:and,
        [:and,
          [:not,
            [:eq, [:var, :type], [:val, 'foo']]],
          [:not,
            [:or,
              [:eq, [:var, :type], [:val, 'bar']],
              [:eq, [:var, :type], [:val, 'baz']]]]],
        [:not, [:eq, [:var, :type], [:val, 'buz']]]]
  end

  it 'NOT type = foo AND (NOT type = bar OR NOT type = baz) AND NOT type = buz' do
    should eq \
      [:and,
        [:and,
          [:not,
            [:eq, [:var, :type], [:val, 'foo']]],
          [:or,
            [:not, [:eq, [:var, :type], [:val, 'bar']]],
            [:not, [:eq, [:var, :type], [:val, 'baz']]]]],
        [:not, [:eq, [:var, :type], [:val, 'buz']]]]
  end

  it 'NOT (NOT type = foo AND NOT (NOT type = bar OR NOT type = baz)) OR NOT type = buz' do
    should eq \
      [:or,
        [:not,
          [:and,
            [:not,
              [:eq, [:var, :type], [:val, 'foo']]],
            [:not,
              [:or,
                [:not, [:eq, [:var, :type], [:val, 'bar']]],
                [:not, [:eq, [:var, :type], [:val, 'baz']]]]]]],
        [:not,
          [:eq, [:var, :type], [:val, 'buz']]]]
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
    let(:str) { ['foo', 'bar'] }
    it { expect { subject }.to raise_error(Travis::Conditions::ArgumentError, 'Invalid condition: ["foo", "bar"]') }
  end
end
