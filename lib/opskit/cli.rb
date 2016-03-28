require 'thor'
require 'thor/group'
require 'yaml'

module OpsKit
  class OdinSon < Thor

    desc "apache CONF [TEMPLATE]", "generate apache vhost for with CONF [using TEMPLATE]"
    def apache(conf, template = nil )
      conf = YAML.load_file( conf )
      conf.keys.each do |key|
        conf[(key.to_sym rescue key) || key] = conf.delete(key)
      end
      puts OpsKit::VHost.new.apache_template( template, conf )
    end
  end
end
