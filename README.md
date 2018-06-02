# github-notifier

## Prerequisites

make sure that you have **jq** command installed. **jq** is needed to github API response parsing.

## Installation

To install the application run

```sh
make install
```

It will post files needed to scheduled run into /Library/LaunchDaemons files of MacOS.

If you want to revert the actions of install then run


```sh
make uninstall
```

## Configurations

The application is designed to run for multiple github instances on the same time.One instance is github.com the others are github enterprise instances.
Generally you will need to have one or two configurations. You can list, create, remove, activate and deactivate configurations. to get the help for configure.sh just run.

```sh
./configure.sh
````

# Testing

if something is not working in your system and you are sure that configurations are correct you can run unit tests for your system to see if system behaves correctly. For this you need to install test framework shell scripts and run unit tests locally

```sh
brew install shunit2
make test
```

# Troubleshooting

to check the daemon logs for the error use

```sh
tail -f /var/log/system.log
```
