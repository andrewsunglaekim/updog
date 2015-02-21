require_relative '../rails_helper'

describe Site do
  it "should have a name" do
    s = Site.new( name: 'jjohn' )
    expect(s.name).to eq('jjohn')
  end
  it "should replace non-word chars" do
    s = Site.create( name: 'Jimmy Johns' )
    expect(s.name).to eq('jimmy-johns')
    s.destroy
  end
  it "should not end with a hyphen" do
    s = Site.create( name: 'Jimmy Johns!' )
    expect(s.name).to eq('jimmy-johns')
    s.destroy
  end
  it "should not end with a hyphen" do
    s = Site.create( name: 'Jimmy Johns!!!' )
    expect(s.name).to eq('jimmy-johns')
    s.destroy
  end
  it "should not start with a hyphen" do
    s = Site.create( name: '!!!Jimmy Johns!!!' )
    expect(s.name).to eq('jimmy-johns')
    s.destroy
  end
end