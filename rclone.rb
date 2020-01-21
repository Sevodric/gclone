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
  puts "Clone one or more repository(ies) from GitHub"
  exit
end

# The configuration file uses the standard $HOME/.config/ directory and contains
# nothing more than the default GitHub ID
CONFIG_DIR = File.join(Dir.home, ".config", "rclone")
CONFIG_PATH = File.join(CONFIG_DIR, "config")

# Check the existence of the $HOME/.config/rclone/ directory
Dir.mkdir(CONFIG_DIR) if !Dir.exist?(CONFIG_DIR)

i = 0
while i < ARGV.length do
  # Set default GitHub ID if asked and exit
  if ARGV[i] == "--set-default"
    File.open(CONFIG_PATH, "w") { |f| f.write(ARGV[i + 1]) }
    puts "The default GitHub ID has been set to: '" + ARGV[i + 1] + "'"
    exit
  end
  
  # Clone current repository
  if ARGV[i].include?("/")
    system("git", "clone", "https://github.com/" + ARGV[i])
  else
    # Prompt for a default GitHub ID if it doesn't exist yet
    if File.exist?(CONFIG_PATH)
      githubID = File.read(CONFIG_PATH)
    else
      puts "No default ID found, please enter a default GitHub ID..."
      githubID = STDIN.gets.chomp
      File.open(CONFIG_PATH, "w") { |f| f.write(githubID) }
      puts "Default GitHub ID has been set to: '" + githubID + "'"
    end
    system("git", "clone", "https://github.com/" + githubID + "/" + ARGV[i])
  end
  i += 1
end
