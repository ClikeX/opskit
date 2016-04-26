require 'thor'
require 'thor/actions'
require 'yaml'

module OpsKit
  class OdinSon < Thor
    include Thor::Actions

    desc "export", "Generates vhost and host file config"
    def export
      conf = {}
      conf[:url] = ask "What is the dev url?"
      conf[:docroot] = ask "What is the docroot?"

      if yes?("Is it a custom template? y/n")
        conf[:template_path] = ask "What is the template path?"
      else
        conf[:template] = ask "What is the template?"
      end

      vhost = OpsKit::VHost.new( conf )

      system "echo '#{vhost.render}' | sudo tee #{ vhost.vhost_location }"
      system "echo '127.0.0.1\t#{ conf[:url]}' | sudo tee -a /etc/hosts"
    end
  end
end
