module OpsKit
  class VHost
    PROVIDERS = [:apache, :nginx]

    attr_reader :provider, :conf

    def initialize( provider = nil, conf = {} )
      @provider = provider
      @conf = conf
    end

    def render
      raise NotImplementedError "No template specified" unless @provider

      if PROVIDERS.include? @provider.to_sym
        file_path = File.join( File.dirname(__FILE__), "templates/#{ @provider }.erb.conf" )
      else
        file_path = @provider
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
