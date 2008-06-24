require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "match_bitap" do
  before(:each) do
    RDiffMatchPatch::Match::match_balance = 0.5
    RDiffMatchPatch::Match::match_threshold = 0.5
  end
  
  it "should be able to find an exact match with the start index set to a non-zero integer" do
    match_bitap("abcdefghijk", "fgh", 5).should == 5
  end

  it "should be able to find an exact match with the start index set to zero" do
    match_bitap("abcdefghijk", "fgh", 5).should == 5
  end

  it "should be able to find a fuzzy match with the start index set to zero" do
    match_bitap("abcdefghijk", "efxhi", 0).should == 4
  end

  it "should be able to find a fuzzy match with the start index set to a non-zero integer" do
    match_bitap("abcdefghijk", "cdefxyhijk", 5).should == 2
    match_bitap("abcdefghijk", "bxy", 1).should == -1
  end

  it "should be able to find a fuzzy match with a high threshold" do
    RDiffMatchPatch::Match::match_threshold = 0.75
    
    RDiffMatchPatch::Match::match_threshold.should == 0.75
    match_bitap("abcdefghijk", "efxyhi", 1).should == 4
  end

  it "should be able to find a fuzzy match with a low threshold" do
    RDiffMatchPatch::Match::match_threshold = 0.1
    
    RDiffMatchPatch::Match::match_threshold.should == 0.1
    match_bitap("abcdefghijk", "bcdef", 1).should == 1
  end
  
  it "should be able to find a fuzzy match with strict location and loose accuracy" do
    RDiffMatchPatch::Match::match_balance = 0.6
    match_bitap("abcdefghijklmnopqrstuvwxyz", "abcdefg", 24).should == -1
    match_bitap("abcdefghijklmnopqrstuvwxyz", "abcxdxexfgh", 1).should == 0
  end


  it "should be able to find a fuzzy match with strict accuracy and loose location" do
    RDiffMatchPatch::Match::match_balance = 0.4
    match_bitap("abcdefghijklmnopqrstuvwxyz", "abcdefg", 24).should == 0
    match_bitap("abcdefghijklmnopqrstuvwxyz", "abcxdxexfgh", 1).should == -1
  end
end