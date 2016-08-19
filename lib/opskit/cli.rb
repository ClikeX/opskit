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

      OpsKit.load_conf name

      if Dir.exists? name
        return if no? "This project already exists do you want to overwrite it?"
        clean name
      end

      run "git clone #{repo} #{name}"

      if yes? "create vhost?"
        ask_for_url
        ask_for_docroot

        vhost = OpsKit::VHost.new( OpsKit.conf )
        run "echo '#{vhost.render}' | sudo tee #{vhost.vhost_location}"
        run "sudo a2ensite #{OpsKit.conf[:url]}"
        run "grep -q -F '127.0.0.1 #{OpsKit.conf[:url]}' /etc/hosts || echo '127.0.0.1 #{OpsKit.conf[:url]}' | sudo tee -a /etc/hosts"
        run "sudo service apache2 reload"
      end

    end

    desc "clean", "Cleans a project from your system"
    def clean (name)
      OpsKit.load_conf name

      if Dir.exists? name
        return if no? "This will remove #{OpsKit.conf[:project_root]} are you sure?"
        FileUtils.rm_rf(OpsKit.conf[:project_root])
      else
        return if no? "Can´t find the project continue cleaning?"
      end


      if yes? "clean vhost?"

        ask_for_url
        vhost = OpsKit::VHost.new( OpsKit.conf )

        run "sed '/127.0.0.1 #{OpsKit.conf[:url]}/d' /etc/hosts | sudo tee /etc/hosts"
        run "sudo a2dissite #{OpsKit.conf[:url]}"

        if File.exists? vhost.vhost_location
          run "sudo rm #{vhost.vhost_location}"
        end

        run "sudo service apache2 reload"
      end
    end

    no_commands do
      def ask_for_url
        url = ask "What is the dev url? [#{OpsKit.conf[:url]}]"

        return if url == ""

        OpsKit.conf[:url] = url
      end

      def ask_for_docroot
        path = ask "What is the docroot? [#{OpsKit.conf[:docroot]}]"

        return if path == ""

        if path == "/"
          OpsKit.conf[:docroot] = "#{OpsKit.conf[:project_root]}"
        elsif path.start_with? "/"
          OpsKit.conf[:docroot] = path
        else
          OpsKit.conf[:docroot] = "#{OpsKit.conf[:project_root]}/#{path}"
        end
      end
    end

  end
end
