require "date"
require "fileutils"
require "rubygems"
require "rake/gempackagetask"

version = File.read('VERSION').chomp

rdiff_match_patch_gemspec = Gem::Specification.new do |s|
  s.name             = "rdiff_match_patch"
  s.version          = version
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.summary          = "Ruby Port of the diff_match_patch library"
  s.description      = s.summary
  s.authors          = ["Arun Thampi"]
  s.email            = "arun.thampi@gmail.com"
  s.homepage         = "http://github.com/arunthampi/rdiff_match_patch"
  s.require_path     = "lib"
  s.autorequire      = "rdiff_match_patch"
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib}/**/*")
end

Rake::GemPackageTask.new(rdiff_match_patch_gemspec) do |pkg|
  pkg.gem_spec = rdiff_match_patch_gemspec
end

namespace :gem do
  namespace :spec do
    desc "Update rdiff_match_patch.gemspec"
    task :generate do
      File.open("rdiff_match_patch.gemspec", "w") do |f|
        f.puts(rdiff_match_patch_gemspec.to_ruby)
      end
    end
  end
end

task :install => :package do
  sh %{sudo gem install pkg/rdiff_match_patch-#{version}}
end

desc "Remove all generated artifacts"
task :clean => :clobber_package