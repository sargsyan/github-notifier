# github-notifier

## Summary:

Real-time notifications from github and github enterprise instances in your desktop.

<img src="https://github.com/sargsyan/github-notifier/blob/gh-pages/assets/images/Comment%20notification.png" alt="Comment notification" width="50%" height="50%" />

Supported for OS X Yosemite and newer versions

## Instructions for installation and usage 

```sh
brew install sargsyan/github-notifier/github-notifier
github-notifier-install
```

Add more Github enterprise instances or change configurations with

```sh
github-notifier-configure
```

More information on installation is on https://githubnotifier.net/#install

If you like the application, please ★ the repo - it helps!
<br/>
<br/>

## Instructions for playing with source code

### Prerequisites

Make sure that you have **jq** command installed. **jq** is needed to github API response parsing.

### Installation

To install the application run

```sh
make install
```

It will post files needed to scheduled run into /Library/LaunchDaemons files of MacOS.

If you want to revert the actions of install then run


```sh
make uninstall
```

### Configurations

The application is designed to run for multiple github instances on the same time.One instance is github.com the others are github enterprise instances.
Generally you will need to have one or two configurations. You can list, create, remove, activate and deactivate configurations. to get the help for configure.sh just run.

```sh
./configure.sh
````

### Testing

If something is not working in your system and you are sure that configurations are correct you can run unit tests for your system to see if system behaves correctly. For this you need to install test framework shell scripts and run unit tests locally

```sh
brew install shunit2
make test
```

### Troubleshooting

To check the daemon logs for the error use

```sh
tail -f /var/log/system.log
```

if the system logs tell that the application keeps exiting with non-zero exit codes, you can check the service logs in the **~/Library/Logs/github_notif/service.log** file or locate github_notif folder in Mac OSX Console application.
