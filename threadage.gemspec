# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{threadage}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tracey Eubanks (Narshlob)"]
  s.date = %q{2010-07-29}
  s.description = %q{A simple library for managing a pool of threads}
  s.email = %q{traceyeubanks@yahoo.com}
  s.extra_rdoc_files = ["lib/threadage.rb"]
  s.files = ["Rakefile", "lib/threadage.rb", "threadage.rb", "Manifest", "threadage.gemspec"]
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Threadage"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{threadage}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A simple library for managing a pool of threads}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
