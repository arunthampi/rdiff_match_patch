require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "fuzzy_match" do
  
  it "should return 0 when trying to fuzzy match two strings which are the same" do
    fuzzy_match("abcdef", 1000, "abcdef").should == 0
  end
  
  it "should return 0 when trying to find a pattern in an empty string" do
    fuzzy_match("abcdef", 1, "").should == nil
  end
  
  it "should return a location when trying to find an empty pattern in a non-empty string" do
    fuzzy_match("", 3, "abcdef").should == 3
  end
  
  it "should return the correct index when trying to find an exact match" do
    fuzzy_match("de", 3, "abcdef").should == 3
  end
  
  it "should return the correct index when trying to find a complex match" do
    RDiffMatchPatch::Match::match_threshold = 0.7
    fuzzy_match(" that berry ", 5, "I am the very model of a modern major general.").should == 4
  end
  
end