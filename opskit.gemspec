# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opskit/version'

Gem::Specification.new do |spec|
  spec.name          = "opskit"
  spec.version       = OpsKit::VERSION
  spec.authors       = ["ClikeX\n\n"]
  spec.email         = ["w.s.van.der.meulen@gmail.com"]

  spec.summary       = %q{Simple tool to setup wordpress config}
  spec.description   = %q{Simple tool to setup wordpress configs}
  spec.homepage      = "http://ClikeX.github.io"
  spec.license       = "MIT"


  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files          = Dir['lib/**/*']
  # spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   << 'opskit'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency 'thor', '~> 0.19.1'
  spec.add_runtime_dependency 'erubis', '~> 2.7'
end
