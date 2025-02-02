$LOAD_PATH.unshift File.expand_path("../", __FILE__)
#

require 'colorator'
require 'yaml'
require 'octopress'
require 'safe_yaml/load'

require 'octopress-deploy/version'
require 'octopress-deploy/core_ext'
require 'octopress-deploy/commands'

module Octopress
  module Deploy
    autoload :Git,    'octopress-deploy/git'
    autoload :Rsync,  'octopress-deploy/rsync'
    autoload :S3,     'octopress-deploy/s3'

    METHODS = {
      'git'   => Git,
      'rsync' => Rsync,
      's3'    => S3
    }

    DEFAULT_OPTIONS = {
      :config_file => '_deploy.yml',
      :site_dir => '_site',
    }

    def self.push(options={})
      options = merge_configs(options)
      deployer(options).push
    end

    def self.pull(options={})
      options = merge_configs(options)

      if !File.exists? options[:dir]
        FileUtils.mkdir_p options[:dir]
      end

      deployer(options).pull
    end

    def self.add_bucket(options={})
      options = merge_configs(options)
      get_deployment_method(options).new(options).add_bucket()
    end

    def self.merge_configs(options={})
      options = check_config(options)
      config  = SafeYAML.load(File.open(options[:config_file])).to_symbol_keys
      options = config.deep_merge(options)
    end

    def self.check_config(options={})
      options = options.to_symbol_keys
      options[:config_file] ||= DEFAULT_OPTIONS[:config_file]

      if !File.exists? options[:config_file]
        abort "File not found: #{options[:config_file]}. Create a deployment config file with `octopress deploy init <METHOD>`."
      end

      options
    end

    def self.deployer(options)
      get_deployment_method(options).new(options)
    end

    def self.get_deployment_method(options)
      METHODS[options[:method].downcase]
    end


    def self.site_dir
      if options[:site_dir]
        options[:site_dir]
      elsif File.exist? '_config.yml'
        SafeYAML.load(File.open('_config.yml'))['site_dir'] || '_site'
      else
        '_site'
      end
    end

    # Create a config file
    #
    def self.init_config(options={})
      options = options.to_symbol_keys

      if !options[:method]
        abort "Please provide a deployment method. e.g. #{METHODS.keys}"
      end

      @options = DEFAULT_OPTIONS.deep_merge(options)
      write_config
      check_gitignore
    end

    def self.write_config
      if File.exist?(@options[:config_file]) && !@options[:force]
        abort "A config file already exists at #{@options[:config_file]}. Use --force to overwrite."
      end

      config = get_config.strip
      File.open(@options[:config_file], 'w') { |f| f.write(config) }
      puts "File #{@options[:config_file]} created.".green
      puts "------------------"
      puts "#{config.yellow}"
      puts "------------------"
      puts "Modify these configurations as necessary."
    end

    def self.get_config
      <<-FILE
#{"method: #{@options[:method]}".ljust(40)}  # How do you want to deploy? git, rsync or s3.
#{"site_dir: #{@options[:site_dir]}".ljust(40)}  # Location of your your static site files.

#{get_deployment_method(@options).default_config(@options)}
FILE
    end

    # Checks the repository's .gitignore for the config file
    #
    # returns: Boolean - whether it is present or not.
    #
    def self.check_gitignore
      gitignore = File.join(`git rev-parse --show-toplevel`.strip, ".gitignore")

      if !File.exist?(gitignore) ||
        File.open(gitignore).read.match(/^#{@options[:config_file]}/i).nil?
        puts "Remember to add #{@options[:config_file]} to your .gitignore."
        false
      else
        true
      end
    end

    def self.gem_dir(*subdirs)
      File.expand_path(File.join(File.dirname(__FILE__), '../', *subdirs))
    end

  end
end

begin
  require 'octopress-ink'
  require 'octopress-deploy/docs'
  Octopress::Ink.register_plugin(Octopress::Deploy::DeployDocs)
rescue LoadError
end
