require 'yaml'
require 'fileutils'
require 'securerandom'

class Configurator
  class << self

    def add_project(config_file)
      options = spanish_inquisition
      new(config_file, options).create
      puts "Changes written to #{config_file}"
    end

    private

    def spanish_inquisition
      {}.tap do |options|
        options[:repo] = ask("Which github repo (eg. microsoft/office)? ")
        options[:project] = ask("What's the Transifex project slug? (eg. msoffice)? ")

        options[:github_user] = ask("What's your Github username? ")

        puts "Visit the Github account settings page and create a new personal"
        puts "access token for your project. Copy and paste it below."
        options[:github_token] = ask("Github personal access token: ")

        options[:transifex_user] = ask("What's your Transifex username? ")
        options[:transifex_pass] = ask("What's your Transifex password? ")

        options[:diffs] = ask_b("Submit diffs to Transifex (y or n)? ")
        options[:auto_delete] = ask_b("Automatically delete Transifex resources (y or n)? ")
      end
    end

    def ask(question, default = nil)
      STDOUT.write(question)
      answer = STDIN.gets.strip
      answer.empty? ? default : answer
    end

    def ask_b(question)
      loop do
        answer = ask(question)

        if answer =~ /\A[yYnN]\z/
          break answer.downcase == 'y'
        else
          puts "Please enter either y or n."
        end
      end
    end
  end

  attr_reader :config, :config_file, :options

  def initialize(config_file, options)
    @config = if File.exist?(config_file)
      YAML.load_file(config_file)
    else
      {}
    end

    @config_file = config_file
    @options = options
  end

  def create
    blaze_trail(%w(github repos), config)
    blaze_trail(%w(transifex projects), config)

    config['github']['repos'][options[:repo]] = generate_repo_config
    config['transifex']['projects'][options[:project]] = generate_project_config

    File.open(config_file, 'w+') do |f|
      f.write(YAML.dump(config))
    end
  end

  private

  def blaze_trail(trail, hash)
    trail.inject(hash) do |h, segment|
      h[segment] ||= {}
    end
  end

  def generate_repo_config
    {
      'api_username'   => options[:github_user],
      'api_token'      => options[:github_token],
      'push_source_to' => options[:project],
      'branch'         => branch || 'all',
      'webhook_secret' => github_webhook_secret || SecureRandom.hex,
      'diff_point'     => options[:diffs] ? 'heads/master' : nil
    }
  end

  def generate_project_config
    {
      'tx_config'             => 'git://.tx/config',
      'api_username'          => options[:transifex_user],
      'api_password'          => options[:transifex_pass],
      'push_translations_to'  => options[:repo],
      'webhook_secret'        => transifex_webhook_secret || SecureRandom.hex,
      'auto_delete_resources' => options[:auto_delete] ? 'true' : 'false'
    }
  end

  def dig(*trail)
    trail.inject(config) do |h, segment|
      h.fetch(segment, {})
    end
  end

  def project
    dig('transifex', 'projects', options[:project])
  end

  def repo
    dig('github', 'repos', options[:repo])
  end

  def branch
    repo['branch']
  end

  def github_webhook_secret
    repo['webhook_secret']
  end

  def transifex_webhook_secret
    project['webhook_secret']
  end

end
