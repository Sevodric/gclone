# RClone
A minimal "git clone" shortcut written in Ruby.

## Installation
Dependencies: `git` and `ruby`

To direclty install RClone system-wide, use the provided `install.sh` script:
```
$ git clone https://github.com/Sevodric/rclone && cd rclone/
$ sh install.sh
```

## Usage
The basic command to clone one or more repositories would be:
```
$ rclone user/repo other_user/other_repo
```

A default GitHub ID may be set up using:
```
$ rclone --set-default your_default_ID
```
This allows for directly cloning without specifying the repository's owner ID (useful for one's own repos):
```
$ rclone repo
```
