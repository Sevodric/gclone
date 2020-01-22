#!/usr/bin/env ruby

# === LICENCE ==================================================================
#
# Copyright 2020 Rémi Durieu
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ==============================================================================

# Display help if asked and exit
if ARGV.include?("--help") || ARGV.length < 1
  puts "Usage: rclone GITHUB-ID/REPOSITORY...       Use the given GitHub ID"
  puts "       rclone REPOSITORY...                 Use the default GitHub ID"
  puts "       rclone --set-default GITHUB-ID       Set the default GitHub ID"
  puts "       rclone --help                        Display this help"
  puts "\nClone one or more repositories from GitHub"
  exit
end

GIT_ERROR_MSG = "*** ERROR: 'git' nor found.\nConsider checking for correct "  \
    "installation of the 'git' package. Refer to your distribution's package " \
    "manager for further installation details."

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
  if arg.include?("/") # The argument is of the form "user/repo"

    puts "Cloning from '#{arg}'"
    begin
      if system("git clone https://github.com/#{arg}") == nil
        puts GIT_ERROR_MSG
      end
    rescue Interrupt => e
      puts "\n*** WARNING: cloning interrupted."
    end

  else # The argument is of the form "repo" and uses the default GitHub ID

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
    rescue Interrupt => e
      puts "\n*** WARNING: cloning interrupted."
    end

  end

end
