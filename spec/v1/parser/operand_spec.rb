describe Travis::Conditions::V1::Parser, 'operand' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).operand }

  it 'type' do
    should eq [:var, 'type']
  end

  it 'foo' do
    should eq [:val, 'foo']
  end

  it 'env(foo)' do
    should eq [:call, :env, [[:val, 'foo']]]
  end
end
