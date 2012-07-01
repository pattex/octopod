#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'yaml'

octopod_help = <<HELP
Octopod - Jekyll based podcast delivery for geeks.

Basic Command Line Usage:
  Standard Jekyll commands:
    octopod                                                   # . -> ./_site
    octopod <path to write generated site>                    # . -> <path>
    octopod <path to source> <path to write generated site>   # <path> -> <path>
    octopod import <importer name> <options>                  # imports posts using named import script

  Additional Octopod commands:
    octopod episode                                           # adds a template for a new episode
    octopod deploy                                            # deploys your site

  See 'octopod <command> --help' for more information on a specific command.

Configuration is read from '<source>/_config.yml' but can be overriden
using the following options:

HELP

deploy_help = <<DEPLOY_HELP
octopod deploy - deploys website via rsync

octopod deploy [path to write generated site] [options]

Configuration is read from '<source>/_config.yml' but can be overriden
using the following options:

DEPLOY_HELP

DEFAULT_EXT = '.md'

class OptionParser
  alias_method :_octopod_banner=, :banner=
  def banner=(_)
    return ''
  end
end

def ok_failed(condition)
  if (condition)
    puts "OK"
  else
    puts "FAILED"
  end
end

if ARGV.size > 0 && ARGV[0] == 'deploy'
  options = YAML.load_file(File.join(ROOT_PATH, '_config.yml'))
  opts = OptionParser.new do |opts|
    opts._octopod_banner = deploy_help

    opts.on("--document-root [PATH]", "Path to the document root on the remote machine") do |deploy_document_root|
      options['document_root'] = deploy_document_root
    end

    opts.on("--rsync-delete", "Delete extraneous files from destination dir") do |deploy_rsync_delete|
      options['rsync_delete'] = deploy_rsync_delete
    end

    opts.on("--ssh-host [USER@]<HOST>", "User for login on the remote machine") do |deploy_ssh_host|
      options['ssh_host'] = deploy_ssh_host =~ /\A\w*@.*/ ? deploy_ssh_host : "#{ENV['USER']}@#{deploy_ssh_host}"
    end

    opts.on("--ssh-port [PORT]", "SSH port on the remote machine") do |deploy_ssh_port|
      options['ssh_port'] = deploy_ssh_port.to_i
    end
  end
  opts.parse!

  options['public_dir'] = ARGV[1] ? ARGV[1] : File.join(ROOT_PATH, '_site')
  exclude = ""
  if File.exists?('./rsync-exclude')
    exclude = "--exclude-from '#{File.expand_path('./rsync-exclude')}'"
  end
  puts "## Deploying website via Rsync"

  rsync_command = "rsync -avze 'ssh -p #{options['ssh_port']}' #{exclude} \
    #{"--delete" unless options['rsync_delete'] == false} \
    #{options['public_dir']}/ #{options['ssh_host']}:#{options['document_root']}"

  ok_failed system(rsync_command)
else
  puts octopod_help if ARGV.size > 0 && ARGV[0] == '--help'
  load Gem.bin_path('jekyll', 'jekyll')
end
