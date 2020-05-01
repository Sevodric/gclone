#!/usr/bin/env ruby
# frozen_string_literal: true

# Displays help if asked and exit
if ARGV.include?('--help') || ARGV.empty?
  puts 'Usage: gclone GITHUB-ID/REPOSITORY...       Use the given GitHub ID'
  puts '       gclone REPOSITORY...                 Use the default GitHub ID'
  puts '       gclone GITHUB-URL...                 Use a full GitHub URL'
  puts '       gclone --set-default GITHUB-ID       Set the default GitHub ID'
  puts '       gclone --help                        Display this help'
  puts 'Quickly clone one or more repositories from GitHub'
  exit
end

GIT_ERROR_MSG = '[ERROR] `git` not found. Consider checking for correct ' \
  'installation of the `git` package. Refer to your distribution\'s package ' \
  'manager for further installation details.'

INTERRUPT_MSG = "\n[WARNING] Cloning interrupted."

# The configuration file uses the standard $HOME/.config/ directory and contains
# nothing more than the default GitHub ID
CONFIG_DIR = File.join(Dir.home, '.config', 'gclone')
CONFIG_PATH = File.join(CONFIG_DIR, 'config')

# Ensures the '~/.config/gclone/' directory does exist
Dir.mkdir(CONFIG_DIR) unless Dir.exist?(CONFIG_DIR)

# Sets the default GitHub ID.
def update_default_id(id)
  File.open(CONFIG_PATH, 'w') { |f| f.write(id) }
  puts "Default GitHub ID set to: #{id}"
  exit
end

# Clones from a full repo link.
def clone_from_full_link(link)
  puts "[INFO] Cloning from #{link}"
  begin
    puts GIT_ERROR_MSG if system("git clone #{link}").nil?
  rescue Interrupt
    puts INTERRUPT_MSG
  end
end

# Clones from an argument of the form id/repo.
def clone_from_couple(arg)
  puts "[INFO] Cloning from '#{arg}'"
  begin
    puts GIT_ERROR_MSG if system("git clone https://github.com/#{arg}").nil?
  rescue Interrupt
    puts INTERRUPT_MSG
  end
end

# Clones from the default GitHub ID.
def clone_from_default(repo)
  github_id = retrieve_default_id
  puts "[INFO] Cloning from '#{github_id}/#{repo}' (default GitHub ID)"
  begin
    if system("git clone https://github.com/#{github_id}/#{repo}").nil?
      puts GIT_ERROR_MSG
    end
  rescue Interrupt
    puts INTERRUPT_MSG
  end
end

# Returns the default GitHub ID.
def retrieve_default_id
  if File.exist?(CONFIG_PATH)
    github_id = File.read(CONFIG_PATH)
  else
    puts 'No default ID found, please enter a default GitHub ID...'
    github_id = STDIN.gets.chomp
    File.open(CONFIG_PATH, 'w') { |f| f.write(github_id) }
    puts "Default GitHub ID set to: '#{github_id}'"
  end
  github_id
end

ARGV.each_with_index do |arg, index|
  if arg == '--set-default'
    update_default_id(ARGV[index + 1])
  elsif %r{https://github\.com/[[:ascii:]]+/[[:ascii:]]+\.git}.match?(arg)
    clone_from_full_link(arg)
  elsif %r{\A[[:alnum:]]+/[[:alnum:]]+}.match?(arg)
    clone_from_couple(arg)
  else
    clone_from_default(arg)
  end
end
