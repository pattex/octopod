require 'rake'
require 'yaml'

ROOT_PATH = '.'

PATHS = { :episodes => File.join(ROOT_PATH, '_episodes') }

DEFAULT_EXT = '.md'

site_config = YAML.load_file(File.join(ROOT_PATH, '_config.yml'))

episode_header = {
  'title'    => nil,
  'layout'   => 'podcast',
  'tags'     => ['podcast'],
  'subtitle' => nil,
  'author'   => site_config['author'],
  'explicit' => site_config['explicit'] || 'no',
  'summary'  => nil,
  'duration' => nil
}

desc "Puts a new podcast episode template in #{PATHS[:episodes]}."
task :episode do
  if ENV['title'].nil?
    abort('Usage: rake episode title="Title of your episode"')
  end

  abort("rake aborted: '#{PATHS[:episodes]}' directory not found.") unless FileTest.directory?(PATHS[:episodes])

  episode_header['title'] = ENV['title']
  slug = episode_header['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '_')
  date = Time.now.strftime('%Y-%m-%d')

  filename = File.join(PATHS[:episodes], "#{date}-#{slug}#{DEFAULT_EXT}")

  abort() unless write_file?(filename)

  open(filename, 'w') do |episode|
    episode.puts episode_header.to_yaml
    episode.puts '---'
    episode.puts 'Insert eloquent and worth reading article here.'
  end

  puts "Created new episode: #{filename}" if File.exists?(filename)
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
