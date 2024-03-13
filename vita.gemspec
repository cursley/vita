require_relative "lib/vita/version"

Gem::Specification.new do |spec|
  spec.name = "vita"
  spec.version = Vita::VERSION
  spec.authors = ["Alec Cursley"]
  spec.email = ["alec@cursley.net"]

  spec.summary = "A tool for tending and publishing a digital garden"
  spec.homepage = "https://github.com/cursley/vita"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["vita"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "redcarpet", "~> 3.6.0"
  spec.add_runtime_dependency "org-ruby", "~> 0.9.12"
  spec.add_runtime_dependency "launchy", "~> 2.5"
  spec.add_runtime_dependency "sinatra", "~> 4.0"
  spec.add_runtime_dependency "rackup", "~> 2.1"
  spec.add_runtime_dependency "puma", "~> 6.4"

  spec.add_development_dependency "rake", "~> 13.1"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rspec-collection_matchers", "~> 1.2"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
  spec.add_development_dependency "rack-test", "~> 2.1"
  spec.add_development_dependency "standard", "~> 1.35.1"
end
