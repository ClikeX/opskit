require 'thor'
require 'thor/group'
require 'yaml'

module OpsKit
  class OdinSon < Thor
    class_option :dry, type: :boolean

    desc "render TEMPLATE", "generate apache vhost for TEMPLATE."
    def render(template = nil)
      conf = YAML.load_file( '.opskit.yml' ) if File.exist? ( '.opskit.yml' )
      conf.keys.each do |key|
        conf[(key.to_sym rescue key) || key] = conf.delete(key)
      end
      vhost = OpsKit::VHost.new( conf )

      if options[:dry]
        puts vhost.render
      else
        #TODO Should write to site-available
        puts vhost.vhost_location
      end
    end
  end
end
