require 'thor'
require 'thor/group'
require 'yaml'

module OpsKit
  class OdinSon < Thor
    class_option :dry, type: :boolean

    desc "render TEMPLATE [CONF]", "generate apache vhost for TEMPLATE with [CONF] ."
    def render(template, conf = '.opskit.yml')
      conf = YAML.load_file( conf )
      conf.keys.each do |key|
        conf[(key.to_sym rescue key) || key] = conf.delete(key)
      end
      vhost = OpsKit::VHost.new( template, conf )

      if options[:dry]
        puts vhost.render
      else
        #TODO Should write to site-available
        puts vhost.vhost_location
      end
    end
  end
end
