describe Travis::Conditions::V1::Parser, 'list' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).list }

  it 'foo,bar' do
    should eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo, bar' do
    should eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo ,bar' do
    should eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo , bar' do
    should eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo, bar, ' do
    should eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo' do
    should eq [[:val, 'foo']]
  end

  it 'type' do
    should eq [[:var, :type]]
  end

  it 'env(foo)' do
    should eq [[:call, :env, [[:val, 'foo']]]]
  end
end
