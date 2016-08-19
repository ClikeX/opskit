require 'erubis'
require "fileutils"
require "opskit/version"
require "opskit/cli"
require "opskit/vhost"
require "opskit/host"
require "opskit/configuration"
require 'thor/actions'

module OpsKit

	class << self
		attr_accessor :configuration
	end

  def self.configure name
    self.configuration ||= Configuration.new(name)
    #yield(configuration) #Not sure if we need somthing like initializers
  end
end
