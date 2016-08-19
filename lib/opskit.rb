require 'erubis'
require "fileutils"
require "opskit/version"
require "opskit/cli"
require "opskit/vhost"
require "opskit/host"
require 'thor/actions'

module OpsKit

	class << self; 
		include Thor::Actions
		attr_accessor :conf; 
	end

	self.conf = {}

    def self.load_conf name=nil

      if name 
      	@conf[:name] = name
      	@conf[:project_root] = "#{Dir.pwd}/#{name}" # get default location for project folders from .opskit.yalm or something
      	@conf[:url] = "dev.#{name}.nl"
      	@conf[:template] = "apache"
      	@conf[:docroot] = "#{@conf[:project_root]}/httpdocs"
      end
    end
end
