module OpsKit
  class VHost
    PROVIDERS = Dir.entries( File.join( File.dirname(__FILE__), "templates/" ) ).select {|f| !File.directory? f}.map{ |e| e.split('.').first.to_sym }

    attr_reader :provider, :conf

    def initialize( provider = nil, conf = {} )
      @provider = provider
      @conf = conf
    end

    def render
      raise NotImplementedError "No template specified" unless @provider

      if PROVIDERS.include? @provider.to_sym
        file_path = File.join( File.dirname(__FILE__), "templates/#{ @provider }.erb.conf" )
      elsif @conf[ :template_path ]
        file_path = @conf[ :template ]
      end

      template = File.read( file_path )
      vhost = Erubis::Eruby.new( template )
      vhost.result(@conf)
    end

    def vhost_location
      case @provider.to_sym
      when :apache
        "/etc/apache2/sites-available/#{ @conf[:url] }.conf"
      end
    end
  end
end
