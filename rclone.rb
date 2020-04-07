#!/usr/bin/env ruby

# Display help if asked and exit
if ARGV.include?("--help") || ARGV.length < 1
  puts "Usage: rclone GITHUB-ID/REPOSITORY...       Use the given GitHub ID"
  puts "       rclone REPOSITORY...                 Use the default GitHub ID"
  puts "       rclone GITHUB-URL...                 Use the full GitHub URL"
  puts "       rclone --set-default GITHUB-ID       Set the default GitHub ID"
  puts "       rclone --help                        Display this help"
  puts "\nQuickly clone one or more repositories from GitHub"
  exit
end

GIT_ERROR_MSG = "[ERROR] 'git' nor found.\nConsider checking for correct " \
  "installation of the 'git' package. Refer to your distribution's package " \
  "manager for further installation details."

INTERRUPT_MSG = "\n[WARNING] Cloning interrupted."

# The configuration file uses the standard $HOME/.config/ directory and contains
# nothing more than the default GitHub ID
CONFIG_DIR = File.join(Dir.home, ".config", "rclone")
CONFIG_PATH = File.join(CONFIG_DIR, "config")

# Ensure the "~/.config/rclone/" directory does exist
Dir.mkdir(CONFIG_DIR) if !Dir.exist?(CONFIG_DIR)

# Main loop
ARGV.each_with_index do |arg, index|

  # Set default GitHub ID if asked and exit
  if arg == "--set-default"
    File.open(CONFIG_PATH, "w") { |f| f.write(ARGV[index + 1]) }
    puts "Default GitHub ID set to: '#{ARGV[index + 1]}'"
    exit
  end

  # Clone the repository from the current argument
  if /https:\/\/github\.com\/[[:ascii:]]+\/[[:ascii:]]+\.git/.match?(arg)
    puts "cloning from #{arg}"
    begin
      if system("git clone #{arg}") == nil
        puts GIT_ERROR_MSG
      end
    rescue Interrupt
      puts INTERRUPT_MSG
    end
  elsif /\A[[:alnum:]]+\/[[:alnum:]]+/.match?(arg)
    puts "Cloning from '#{arg}'"
    begin
      if system("git clone https://github.com/#{arg}") == nil
        puts GIT_ERROR_MSG
      end
    rescue Interrupt
      puts INTERRUPT_MSG
    end
  else  
    # If the default GitHub ID doesn't exist yet, ask for it
    if !File.exist?(CONFIG_PATH)
      puts "No default ID found, please enter a default GitHub ID..."
      github_id = STDIN.gets.chomp
      File.open(CONFIG_PATH, "w") { |f| f.write(github_id) }
      puts "Default GitHub ID set to: '#{github_id}'"
    else
      # Get the default GitHub ID from the config file
      github_id = File.read(CONFIG_PATH)
    end
    puts "Cloning from '#{github_id}/#{arg}'"
    begin
      if system("git clone https://github.com/#{github_id}/#{arg}") == nil
        puts GIT_ERROR_MSG
      end
    rescue Interrupt
      puts INTERRUPT_MSG
    end
  end
end
