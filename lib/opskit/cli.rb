require 'thor'
require 'thor/actions'
require 'yaml'
require 'fileutils'

module OpsKit
  class OdinSon < Thor
    include Thor::Actions

    desc "setup", "Setup a project based on a git repo"
    def setup (repo, name=nil)
      if !name
        name = repo.split('/').last.split(".").first
      end

      OpsKit.configure name

      if Dir.exists? name
        return if no? "This project already exists do you want to overwrite it?"
        clean name
      end

      run "git clone #{repo} #{name}"

      if yes? "create vhost?"
        ask_for_url
        ask_for_docroot

        vhost = OpsKit::VHost.new( {template: OpsKit.configuration.template, url: OpsKit.configuration.url, docroot: OpsKit.configuration.docroot } )
        run "echo '#{vhost.render}' | sudo tee #{vhost.vhost_location}"
        run "sudo a2ensite #{vhost.conf[:url]}"
        run "grep -q -F '127.0.0.1 #{vhost.conf[:url]}' /etc/hosts || echo '127.0.0.1 #{vhost.conf[:url]}' | sudo tee -a /etc/hosts"
        run "sudo service apache2 reload"
      end

    end

    desc "clean", "Cleans a project from your system"
    def clean (name)
      OpsKit.configure name

      if Dir.exists? name
        return if no? "This will remove #{OpsKit.configuration.project_root} are you sure?"
        FileUtils.rm_rf(OpsKit.configuration.project_root)
      else
        return if no? "Can´t find the project continue cleaning?"
      end


      if yes? "clean vhost?"

        ask_for_url
        vhost = OpsKit::VHost.new( {template: OpsKit.configuration.template, url: OpsKit.configuration.url, docroot: OpsKit.configuration.docroot } )

        run "sed '/127.0.0.1 #{vhost.conf[:url]}/d' /etc/hosts | sudo tee /etc/hosts"
        run "sudo a2dissite #{vhost.conf[:url]}"

        if File.exists? vhost.vhost_location
          run "sudo rm #{vhost.vhost_location}"
        end

        run "sudo service apache2 reload"
      end
    end

    no_commands do
      def ask_for_url
        url = ask "What is the dev url? [#{OpsKit.configuration.url}]"

        return if url == ""

        OpsKit.configuration.url = url
      end

      def ask_for_docroot
        path = ask "What is the docroot? [#{OpsKit.configuration.docroot}]"

        return if path == "" || path == "/"

        if path.start_with? "/"
          OpsKit.configuration.docroot = path
        else
          OpsKit.configuration.docroot = "#{OpsKit.configuration.docroot}/#{path}"
        end
      end
    end

  end
end
