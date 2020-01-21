# RClone
A minimal "git clone" shortcut written in Ruby

## Installation
To direclty install RClone systemwide, clone this repository (without RClone :p) and use the provided `install.sh` script:
```
$ git clone https://github.com/Sevodric/rclone && cd rclone/
$ sh install.sh
```

## Usage
The basic command to clone https://github.com/user/repo would be:
```
$ rlcone user/repo
```

Alternatively, a default GitHub ID may be set up using:
```
$ rclone --set-default your_default_ID
```
It allows for directly cloning without specifying the repository's owner ID:
```
$ rclone repo
```
