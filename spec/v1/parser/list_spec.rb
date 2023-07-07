describe Travis::Conditions::V1::Parser, 'list' do
  let(:str) { |e| e.description }
  let(:subject) { described_class.new(str).list }

  it 'foo,bar' do
    expect(subject).to eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo, bar' do
    expect(subject).to eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo ,bar' do
    expect(subject).to eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo , bar' do
    expect(subject).to eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo, bar,' do
    expect(subject).to eq [[:val, 'foo'], [:val, 'bar']]
  end

  it 'foo' do
    expect(subject).to eq [[:val, 'foo']]
  end

  it 'type' do
    expect(subject).to eq [%i[var type]]
  end

  it 'env(foo)' do
    expect(subject).to eq [[:call, :env, [[:val, 'foo']]]]
  end
end
