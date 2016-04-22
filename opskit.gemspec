# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opskit/version'

Gem::Specification.new do |spec|
  spec.name          = "opskit"
  spec.version       = OpsKit::VERSION
  spec.authors       = ["ClikeX\n\n"]
  spec.email         = ["w.s.van.der.meulen@gmail.com"]

  spec.summary       = %q{Command line tool to simplify setting up dev environments}
  spec.description   = %q{
                          This command line tool allows dev to easily set up their dev environments so they don't have to waste time.
                        }
  spec.homepage      = "https://github.com/ClikeX/opskit"
  spec.license       = "MIT"

  spec.files          = Dir['lib/**/*']
  spec.bindir        = "bin"
  spec.executables   << 'opskit'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency 'thor', '~> 0.19.1'
  spec.add_runtime_dependency 'erubis', '~> 2.7'
end
