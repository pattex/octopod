require 'rake'
require 'yaml'

ROOT_PATH = '.'

DEFAULT_EXT = '.md'

site_config = YAML.load_file(File.join(ROOT_PATH, '_config.yml'))

PATHS = {
  :posts      => File.join(ROOT_PATH, '_posts'),
  :public_dir => File.join(ROOT_PATH, '_site')
}

post_header = {
  'title'    => nil,
  'layout'   => 'post',
  'tags'     => ['podcast'],
  'subtitle' => nil,
  'author'   => site_config['author'],
  'explicit' => site_config['explicit'] || 'no',
  'summary'  => nil,
  'duration' => nil
}

task :default => [:build]

desc "Builds the website."
task :build do
  system('jekyll')
end

desc "Runs the site on a local webserver."
task :server do
  system('jekyll --auto --server')
end

desc "Puts a new podcast episode template in #{PATHS[:posts]}."
task :episode do
  if ENV['title'].nil?
    abort('Usage: rake episode title="Title of your episode"')
  end

  unless FileTest.directory?(PATHS[:posts])
    abort("rake aborted: '#{PATHS[:posts]}' directory not found.")
  end

  post_header['title'] = ENV['title']
  slug = post_header['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '_')
  date = Time.now.strftime('%Y-%m-%d')

  filename = File.join(PATHS[:posts], "#{date}-#{slug}#{DEFAULT_EXT}")

  abort() unless write_file?(filename)

  open(filename, 'w') do |post|
    post.puts post_header.to_yaml
    post.puts '---'
    post.puts "Insert eloquent and worth reading text here.\n\n"
    post.puts "## Shownotes\n* Note"
  end

  puts "Created new episode: #{filename}" if File.exists?(filename)
end

desc "Deploy website via rsync"
task :deploy => :build do
  exclude = ""
  if File.exists?('./rsync-exclude')
    exclude = "--exclude-from '#{File.expand_path('./rsync-exclude')}'"
  end
  puts "## Deploying website via Rsync"

  rsync_command = "rsync -avze 'ssh -p #{site_config['ssh_port']}' #{exclude} \
    #{"--delete" unless site_config['rsync_delete'] == false} \
    #{PATHS[:public_dir]}/ #{site_config['ssh_user']}:#{site_config['document_root']}"

  ok_failed system(rsync_command)
end

def write_file?(filename)
  if File.exists?(filename)
    'y' == ask("Fiel '#{filename}' already exists. Overwrite?", ['y', 'n'])
  else
    true
  end
end

def ask(message, valid_options = nil)
  if valid_options
    answer = get_stdin("#{message} #{valid_options.to_s.gsub(/"/, '').gsub(/, /,'/')} ") while !valid_options.include?(answer)
  else
    answer = get_stdin(message)
  end
  answer
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end

def ok_failed(condition)
  if (condition)
    puts "OK"
  else
    puts "FAILED"
  end
end
