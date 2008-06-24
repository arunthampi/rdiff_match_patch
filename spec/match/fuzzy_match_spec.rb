require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "fuzzy_match" do
  before(:each) do
    class Dummy
      include RDiffMatchPatch::Match
    end
  end
  
  it "should return 0 when trying to fuzzy match two strings which are the same" do
    Dummy.new.fuzzy_match("abcdef", 1000, "abcdef").should == 0
  end
  
  it "should return 0 when trying to find a pattern in an empty string" do
    Dummy.new.fuzzy_match("abcdef", 1, "").should == nil
  end
  
  it "should return a location when trying to find an empty pattern in a non-empty string" do
    Dummy.new.fuzzy_match("", 3, "abcdef").should == 3
  end
  
  it "should return the correct index when trying to find an exact match" do
    Dummy.new.fuzzy_match("de", 3, "abcdef").should == 3
  end
  
  it "should return the correct index when trying to find a complex match" do
    Dummy.match_threshold = 0.7
    Dummy.new.fuzzy_match(" that berry ", 5, "I am the very model of a modern major general.").should == 4
  end
  
end