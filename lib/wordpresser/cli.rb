require 'thor'
require 'thor/group'
require 'yaml'

module Wordpresser
  class OdinSon < Thor

    desc "apache CONF [TEMPLATE]", "generate apache vhost for with CONF [using TEMPLATE]"
    def apache(conf, template = nil )
      conf = YAML.load_file( conf )
      conf.keys.each do |key|
        conf[(key.to_sym rescue key) || key] = conf.delete(key)
      end
      puts Wordpresser::VHost.new.gen_template( template, conf )
    end
  end
end
