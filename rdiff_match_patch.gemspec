Gem::Specification.new do |s|
  s.name = %q{rdiff_match_patch}
  s.version = "0.0.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Arun Thampi"]
  s.autorequire = %q{rdiff_match_patch}
  s.date = %q{2008-06-24}
  s.description = %q{Ruby Port of the diff_match_patch library}
  s.email = %q{arun.thampi@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/match.rb", "lib/rdiff_match_patch.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/arunthampi/rdiff_match_patch}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{Ruby Port of the diff_match_patch library}
end
