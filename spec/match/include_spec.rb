require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Including the RDiffMatchPatch module as part of a class" do
  before(:each) do
    class String
      include RDiffMatchPatch::Match
    end
  end
  
  it "should add fuzzy_match as an instance method of that class" do
    String.new.methods.include?('fuzzy_match').should == true
  end
  
  it "should be able to fuzzy match a string correctly" do
    String.match_balance = 0.75
    "I am the very model of a modern major general.".fuzzy_match(" that berry ", 5).should == 4
  end
  
end