module OpsKit
  class VHost

    def apache_available?
      File.directory?('/etc/apache2/sites-available/')
    end

    def gen_template( template = nil, options = {})
      raise NotImplementedError "Apache folder not available" unless self.apache_available?

      file_path = File.join( File.dirname(__FILE__), 'templates/apache.erb.conf' ) unless template
      file_path = template if template

      template = File.read( file_path )
      template = Erubis::Eruby.new(template)
      template.result(options)
    end
  end
end
