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
        name = repo.split('/').last.split(".git").first
      end

      OpsKit.configure name

      if Dir.exist? OpsKit.configuration.project_root
        return if no? "This project already exists do you want to overwrite it?"
        clean name
      end

      say "Cloning repo into #{OpsKit.configuration.project_root}", :cyan
      run "git clone #{repo} #{name}"

      if yes? "create vhost?"
        ask_for_url
        ask_for_docroot

        vhost = OpsKit::VHost.new( {template: OpsKit.configuration.template, url: OpsKit.configuration.url, docroot: OpsKit.configuration.docroot } )
        say "Create vhost for #{vhost.conf[:url]} at #{vhost.vhost_location}", :cyan
        run "echo '#{vhost.render}' | sudo tee #{vhost.vhost_location}"
        run "sudo a2ensite #{vhost.conf[:url]}"

        say "Creating hosts entry", :cyan
        run "grep -q -F '127.0.0.1 #{vhost.conf[:url]}' /etc/hosts || echo '127.0.0.1 #{vhost.conf[:url]}' | sudo tee -a /etc/hosts"

        say "Reload the apache2 server", :cyan
        run "sudo service apache2 reload"
      end

      say "Looking for example files to copy"
      example_files = find_example_files OpsKit.configuration.project_root
      puts example_files

      example_files.each do |example_file|

        new_file = example_file.sub(".example", '')
        new_file = new_file.sub("-example", '')
        if yes? "Copy example file #{example_file} to #{new_file}?"
          inside OpsKit.configuration.project_root do
            run "cp #{example_file} #{new_file}"
            run "nano #{new_file}"
          end
        end
      end

      say "Looking for package managers to run"
      pms = find_used_package_managers OpsKit.configuration.project_root
      if yes? "Run the package managers? #{pms}"
        commands = {
          :bundler          => 'bundle install',
          :npm              => 'npm install',
          :composer         => 'composer install',
          :git              => 'git submodule init && git submodule update',
          :bower            => 'bower install'
        }

        inside OpsKit.configuration.project_root do
          pms.each do |pm|
            run commands[pm]
          end
        end
      end
    end

    desc "clean", "Cleans a project from your system"
    def clean (name)
      OpsKit.configure name

      if Dir.exist? OpsKit.configuration.project_root
        return if no? "This will remove #{OpsKit.configuration.project_root} are you sure?"
        FileUtils.rm_rf(OpsKit.configuration.project_root)
      else
        return if no? "Can´t find the project continue cleaning?"
      end

      if yes? "clean vhost?"

        ask_for_url
        vhost = OpsKit::VHost.new(
          template: OpsKit.configuration.template,
          url: OpsKit.configuration.url,
          docroot: OpsKit.configuration.docroot
        )

        if !vhost.conf[:url].to_s.empty?
          say "Removing the hosts entry for #{vhost.conf[:url]}", :cyan
          run "sed '/127.0.0.1 #{vhost.conf[:url]}/d' /etc/hosts | sudo tee /etc/hosts"

          say "Disabling #{vhost.conf[:url]}", :cyan
          run "sudo a2dissite #{vhost.conf[:url]}"
        end

        say "Remove #{vhost.vhost_location}", :cyan
        if File.exist? vhost.vhost_location
          run "sudo rm #{vhost.vhost_location}"
        else
          say "Couldn't find #{vhost.vhost_location}", :red
        end

        say "Reload the apache2 server", :cyan
        run "sudo service apache2 reload"
      end
    end

    desc "update an composer package", "Updates a composer project"
    def update_composer (root)
      pkg = ask "What package name to search versions for?"

      return "#{root} does not exist" if !Dir.exist? root
      inside root do
        return "Not a git project" if !Dir.exist? ".git"
        return "No composer file found" if !File.exist? "composer.json"
        return "No bedrock project" if File.readlines("composer.json").grep(/webroot-installer/).size < 1

        run "git status"
        return if no? "git status looks okay?"

        say File.readlines("composer.json").grep(/http/).join("")
        if yes? "Fix https in composer?"
          run "sed -i 's/http/https/g' composer.json"
        end

        run "grep #{pkg} composer.json"
        old_version = ask "What was the old version"
        new_version = ask "What is the new version"

        run "sed -i 's/#{old_version}/#{new_version}/g' composer.json"
        run "composer update"
        run "git diff"
        run "git status"
        if yes? "commit the changes?"
          git_name = ask "What is the git name (branch = update/?{{version}})"
          git_branch = "update/#{git_name}#{new_version}"

          run "git checkout -b #{git_branch}"
          run "git add composer.json"
          run "git add composer.lock"

          default_commit = "Updated #{git_name} to #{new_version}"
          commit = ask "What is the git commit?" [default_commit]
          commit = default_commit if commit.to_s == ''

          run "git commit '#{commit}'"
          run "git push --set-upstream #{git_branch}"
        end
      end
    end

    no_commands do
      def ask_for_url
        url = ask "What is the dev url? [#{OpsKit.configuration.url}]"

        return if url == ""

        OpsKit.configuration.url = url
      end

      def ask_for_docroot
        run "ls -la #{OpsKit.configuration.docroot}"
        path = ask "What is the docroot? [#{OpsKit.configuration.docroot}]"

        return if path == "" || path == "/"

        if path.start_with? "/"
          OpsKit.configuration.docroot = path
        else
          OpsKit.configuration.docroot = "#{OpsKit.configuration.docroot}/#{path}"
        end
      end

      def find_used_package_managers dir
        pms = []

        file_to_pm = {
          'Gemfile' => :bundler,
          'composer.json' => :composer,
          'package.json' => :npm,
          'bower.json' => :bower,
          '.gitmodules' => :git,
        }

        inside dir do
          pms = `ls -a`.lines.map(&:chomp).select{ |f| file_to_pm.key?(f) }.map{ |f| file_to_pm[f]}
        end

        pms
      end

      def find_example_files dir
        examples = []

        inside dir do
          examples.concat `find . | grep "\\.example"`.lines.map(&:chomp)
          examples.concat `find . | grep "\-example"`.lines.map(&:chomp)
        end

        examples
      end
    end
  end
end
