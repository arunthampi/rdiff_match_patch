require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "match_bitap" do
  before(:each) do
    class Dummy
      include RDiffMatchPatch::Match
    end
    
    Dummy.match_balance = 0.5
    Dummy.match_threshold = 0.5
  end
  
  after(:all) do
    
  end
  
  it "should be able to find an exact match with the start index set to a non-zero integer" do
    Dummy.new.send('match_bitap', "abcdefghijk", "fgh", 5).should == 5
  end

  it "should be able to find an exact match with the start index set to zero" do
    Dummy.new.send('match_bitap', "abcdefghijk", "fgh", 5).should == 5
  end

  it "should be able to find a fuzzy match with the start index set to zero" do
    Dummy.new.send('match_bitap', "abcdefghijk", "efxhi", 0).should == 4
  end

  it "should be able to find a fuzzy match with the start index set to a non-zero integer" do
    Dummy.new.send('match_bitap', "abcdefghijk", "cdefxyhijk", 5).should == 2
    Dummy.new.send('match_bitap', "abcdefghijk", "bxy", 1).should == -1
  end

  it "should be able to find a fuzzy match with a high threshold" do
    Dummy.match_threshold = 0.75
    
    Dummy.match_threshold.should == 0.75
    Dummy.new.send('match_bitap', "abcdefghijk", "efxyhi", 1).should == 4
  end

  it "should be able to find a fuzzy match with a low threshold" do
    Dummy.match_threshold = 0.1
    
    Dummy.match_threshold.should == 0.1
    Dummy.new.send('match_bitap', "abcdefghijk", "bcdef", 1).should == 1
  end
  
  it "should be able to find a fuzzy match with strict location and loose accuracy" do
    Dummy.match_balance = 0.6
    Dummy.match_balance.should == 0.6
    
    Dummy.new.send('match_bitap', "abcdefghijklmnopqrstuvwxyz", "abcdefg", 24).should == -1
    Dummy.new.send('match_bitap', "abcdefghijklmnopqrstuvwxyz", "abcxdxexfgh", 1).should == 0
  end


  it "should be able to find a fuzzy match with strict accuracy and loose location" do
    Dummy.match_balance = 0.4
    Dummy.match_balance.should == 0.4
    
    Dummy.new.send('match_bitap', "abcdefghijklmnopqrstuvwxyz", "abcdefg", 24).should == 0
    Dummy.new.send('match_bitap', "abcdefghijklmnopqrstuvwxyz", "abcxdxexfgh", 1).should == -1
  end
end