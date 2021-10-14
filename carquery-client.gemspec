require_relative 'lib/carquery/client/version'

Gem::Specification.new do |spec|
  spec.name          = "carquery-client"
  spec.version       = Carquery::Client::VERSION
  spec.authors       = ["Zshawn Syed"]
  spec.email         = ["zsyed91@gmail.com"]

  spec.summary       = %q{Ruby client for accessing carqueryapi.com public API}
  spec.description   = %q{Ruby client providing an interface to https://carqueryapi.com/api}
  spec.homepage      = "https://github.com/zsyed91/carquery-client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zsyed91/carquery-client"
  spec.metadata["changelog_uri"] = "https://github.com/zsyed91/carquery-client"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'faraday', '~> 1.8'
  spec.add_runtime_dependency 'faraday_middleware', '~> 1.1'
end
