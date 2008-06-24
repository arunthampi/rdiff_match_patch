$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'match'
# require 'diff'
# require 'patch'

module RDiffMatchPatch
  # Includes only the matching function
  include RDiffMatchPatch::Match
  # Diff and Patch should be separate modules which are included
  # include RDiffMatchPatch::Diff
  # include RDiffMatchPatch::Patch
  
end