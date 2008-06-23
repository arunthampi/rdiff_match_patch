module RDiffMatchPatch
  MATCH_BALANCE = 0.5
  # At what point is no match declared (0.0 = perfection, 1.0 = very loose)
  MATCH_THRESHOLD = 0.7
  # The min and max cutoffs used when computing text lengths.
  MATCH_MIN_LENGTH = 100
  MATCH_MAX_LENGTH = 1000
  # How many bits in a number?
  # Python has no maximum, disable all patch splitting.
  # If bitwise operations on longs are too slow, try changing this to 32.
  MATCH_MAX_BITS = 0

  # Locate the best instance of 'pattern' in 'text' near 'loc'.
  #
  # Args:
  #  text: The text to search.
  #  pattern: The pattern to search for.
  #  loc: The location to search around.

  # Returns:
  #  Best match index or None.
  def fuzzy_match(text, pattern, loc = 0)
    loc = [0, [loc, text.length - pattern.length].min].max || 0

    if text == pattern
      return 0
    elsif text.nil? || text.length == 0
      return nil
    elsif text[loc...loc + pattern.length] == pattern
      return loc
    else
      match = match_bitap(text, pattern, loc)
      return match
    end
  end

private    
  # Locate the best instance of 'pattern' in 'text' near 'loc' using the
  # Bitap algorithm.

  # Args:
  #  text: The text to search.
  #  pattern: The pattern to search for.
  #  loc: The location to search around.

  # Returns:
  #  Best match index or None.  
  def match_bitap(text, pattern, loc)
    # Initialize the alphabet
    s = match_alphabet(pattern)
    score_text_length = text.length
    # Coerce the text length between reasonable maximums and minimums
    score_text_length = [score_text_length, MATCH_MIN_LENGTH].max
    score_text_length = [score_text_length, MATCH_MAX_LENGTH].min
    
    # Highest score beyond which we give up.
    score_threshold = MATCH_THRESHOLD
    best_loc = text.index(pattern, loc)
    unless best_loc.nil?
      score_threshold = [score_threshold, match_bitap_score(score_text_length, pattern, loc, 0, best_loc)].min
    end
    # What about in the other direction? (speedup)
    best_loc = text.rindex(pattern, loc + pattern.length)
    unless best_loc.nil?
      score_threshold = [score_threshold, match_bitap_score(score_text_length, pattern, loc, 0, best_loc)].min
    end
    
    # Initialize the bit arrays
    match_mask = 1 << (pattern.length - 1)
    best_loc, last_rd = nil, nil
    bin_max = [loc + loc, text.length].max
    
    (0...pattern.length).each do |d|
      rd = (0...text.length).collect { nil }
      # Run a binary search to determine how far from 'loc' we can stray at
      # this error level.
      bin_min, bin_mid = loc, bin_max
      
      while bin_min < bin_mid
        if(match_bitap_score(score_text_length, pattern, loc, d, bin_mid) < score_threshold)
          bin_min = bin_mid
        else
          bin_max = bin_mid
        end
        bin_mid = (bin_max - bin_min) / 2 + bin_min
      end
      
      # Use the result from this iteration as the maximum for the next.
      bin_max = bin_mid
      start = [0, loc - (bin_mid - loc) - 1].max
      finish = [text.length - 1, pattern.length + bin_mid].min
      
      if text[finish] == pattern[-1]
        rd[finish] = (1 << (d + 1)) - 1
      else
        rd[finish] = (1 << d) - 1
      end
      
      j = finish - 1
      
      while(j > start - 1)
        if d == 0 # First pass: exact match.
          rd[j] = (((rd[j + 1] || 0) << 1) | 1) & (s[text[j].chr] || 0)
        else # Subsequent passes: fuzzy match.
          rd[j] = (((rd[j + 1] || 0) << 1) | 1) & (s[text[j].chr] || 0) | (((last_rd[j + 1] || 0) << 1) | 1) | (((last_rd[j] || 0) << 1) | 1) | (last_rd[j + 1] || 0)
        end
        if rd[j] & match_mask
          score = match_bitap_score(score_text_length, pattern, loc, d, j)
          # This match will almost certainly be better than any existing match
          # But check anyway
          if score <= score_threshold
            # Told you so
            score_threshold = score
            best_loc = j
            if j > loc
              start = [0, loc - (j - loc)].max
            else
              break
            end
          end
        end
        
        j = j - 1
      end
      
      # No hope for a (better) match at greater levels
      break if match_bitap_score(score_text_length, pattern, loc, d + 1, loc) > score_threshold
      
      last_rd = rd
    end
    
    return best_loc
  end

  # Compute and return the score for a match with e errors and x location.
  # Accesses loc, score_text_length and pattern through being a closure.
  #
  # Args:
  #  e: Number of errors in match.
  #  x: Location of match.
  #
  # Returns:
  #  Overall score for match.
  def match_bitap_score(score_text_length, pattern, loc, e, x)
    d = (loc - x).abs.to_f
    return (e.to_f / pattern.length / MATCH_BALANCE) + 
            (d / score_text_length / (1.0 - MATCH_BALANCE))
  end


  def match_alphabet(pattern)
    alphabets = {}
    pattern.each_byte {|x| alphabets[x.chr] = 0}
    (0...pattern.length).each { |i| alphabets[pattern[i].chr] |= 1 << (pattern.length - i - 1) }
    
    alphabets
  end

end