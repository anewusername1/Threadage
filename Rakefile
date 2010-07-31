require 'rubygems'
require 'rake'
require 'echoe'
require 'spec/rake/spectask'

Echoe.new('threadage', '0.0.1') do |p|
  p.description    = "A simple library for managing a pool of threads"
  p.url            = ""
  p.author         = "Tracey Eubanks (Narshlob)"
  p.email          = "traceyeubanks@yahoo.com"
  p.ignore_pattern = ["tmp/*"]
  p.development_dependencies = []
end


desc "Run all Threadage specs"
Spec::Rake::SpecTask.new('threadage') do |t|
  t.spec_files = FileList['spec/**/*.rb']
end
