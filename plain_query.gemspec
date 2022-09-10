
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "plain_query/version"

Gem::Specification.new do |spec|
  spec.name          = "plain_query"
  spec.version       = PlainQuery::VERSION
  spec.authors       = ["gl-pv"]
  spec.email         = ["gleeb812812@yandex.ru"]

  spec.summary       = %q{Builds query object by declaration sequence of query building steps}
  spec.description   = %q{PlainQuery is a simple gem that helps you write clear and flexible query objects}
  spec.homepage      = "https://github.com/gl-pv/plain_query"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/gl-pv/plain_query"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '>= 4.2'

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'database_cleaner-active_record', '~> 1.8.0'
  spec.add_development_dependency 'sqlite3', '~> 1.4.2'
end
