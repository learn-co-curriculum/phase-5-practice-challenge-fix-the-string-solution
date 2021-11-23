describe '#fix_the_string' do
  it 'returns the fixed string' do
    expect(fix_the_string('')).to eq('')
    expect(fix_the_string('a')).to eq('a')
    expect(fix_the_string('cCcOdDdInGGgisSSfUUun')).to eq('cOdInGiSfUn')
    expect(fix_the_string('efFEFiiIxyeEYeZdDzd')).to eq('Fixed')
  end
end
