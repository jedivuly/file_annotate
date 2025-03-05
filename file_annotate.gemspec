# frozen_string_literal: true

require_relative "lib/file_annotate/version"

Gem::Specification.new do |spec|
  spec.name = "file_annotate"
  spec.version = FileAnnotate::VERSION
  spec.authors = ["jedivulyliu"]
  spec.email = ["jedivuly@gmail.com"]

  spec.summary = "在 Ruby 檔案的第一行插入檔案路徑註解"
  spec.description = "批次掃描 .rb 檔案並加入路徑註解，並支援 RuboCop 檢查"
  spec.homepage = "https://github.com/jedivuly/file_annotate"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jedivuly/file_annotate"
  spec.metadata["changelog_uri"] = "https://github.com/jedivuly/file_annotate/blob/main/CHANGELOG.md"
  spec.metadata['rubocop_extension'] = 'true'

  spec.add_dependency "rubocop", "~> 1.60"
  spec.add_dependency "thor", "~> 1.0"
  spec.add_development_dependency 'rubocop', '~> 1.60'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["file_annotate"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
