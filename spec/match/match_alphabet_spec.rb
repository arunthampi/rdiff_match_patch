require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "match_alphabet" do
  it "should be able to generate the correct hashmap for a string with unique characters" do
    bitmask = match_alphabet("abc")
    
    bitmask.keys.size.should == 3
    bitmask['a'].should == 4
    bitmask['b'].should == 2
    bitmask['c'].should == 1
  end

  it "should be able to generate the correct hashmap for a string with duplicate characters" do
    bitmask = match_alphabet("abcaba")
    
    bitmask.keys.size.should == 3
    bitmask['a'].should == 37
    bitmask['b'].should == 18
    bitmask['c'].should == 8
  end

end

  