module OpsKit
	class Configuration
    attr_accessor :name
    attr_accessor :project_root
    attr_accessor :url
    attr_accessor :template
    attr_accessor :docroot

    def initialize name
      @name = name
      @project_root = "#{Dir.pwd}/#{name}" # get default location for project folders from ~/.opskit/config.yml or something
      @url = "dev.#{name}.nl"
      @template = "apache"
      @docroot = "#{@project_root}"
    end

	end
end