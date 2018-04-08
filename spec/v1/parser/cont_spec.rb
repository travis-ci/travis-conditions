describe Travis::Conditions::V1::Parser, 'line continuation' do
  let(:str)     { |e| e.description }
  let(:subject) { described_class.new(str).parse }

  # backslashes

  it "1 = 1 AND\\\n2 = 2" do
    should eq \
      [:and,
        [:eq, [:val, '1'], [:val, '1']],
        [:eq, [:val, '2'], [:val, '2']]]
  end

  it "1 = 1 AND \\\n 2 = 2" do
    should eq \
      [:and,
        [:eq, [:val, '1'], [:val, '1']],
        [:eq, [:val, '2'], [:val, '2']]]
  end

  it "1 = 1 AND \\ \n 2 = 2" do
    should eq \
      [:and,
        [:eq, [:val, '1'], [:val, '1']],
        [:eq, [:val, '2'], [:val, '2']]]
  end

  it "\\\n1 = 1 AND\\\n2 = 2" do
    should eq \
      [:and,
        [:eq, [:val, '1'], [:val, '1']],
        [:eq, [:val, '2'], [:val, '2']]]
  end

  it "\\\n1 = 1 AND\\\n2 = 2\\\n" do
    should eq \
      [:and,
        [:eq, [:val, '1'], [:val, '1']],
        [:eq, [:val, '2'], [:val, '2']]]
  end
end
