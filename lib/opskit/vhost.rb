module OpsKit
  class VHost
    PROVIDERS = Dir.entries( File.join( File.dirname(__FILE__), "templates/" ) ).select {|f| !File.directory? f}.map{ |e| e.split('.').first.to_sym }

    attr_reader :conf

    def initialize( conf = {} )
      @conf = conf
    end

    def render
      if PROVIDERS.include? @conf[ :template ].to_sym
        file_path = File.join( File.dirname(__FILE__), "templates/#{ @conf[ :template ] }.erb.conf" )
      elsif @conf[ :template ]
        file_path = @conf[ :template ]
      end

      template = File.read( file_path )
      vhost = Erubis::Eruby.new( template )
      vhost.result(@conf)
    end

    def vhost_location
      case @conf[ :template ].to_sym
      when :apache
        "/etc/apache2/sites-available/#{ @conf[:url] }.conf"
      end
    end
  end
end
