# Table of Contents

- [Tips and tricks](#tips-and-tricks)
- [How to generate github notifications token](#how-to-generate-github-notifications-token)
- [Comparison to other tools and techniques](#comparison-to-other-tools-and-techniques)
- [Configurations](#configurations)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

# Tips and tricks

to check the whole body of the Pull request/Issue or comments long descriptions, users can hover mouse on the bottom part of the popup. When the mouse icon will change accordingly users can expand the popup and read whole message. The popup will not disappear until mouse is on the popup.

# How to generate github notifications token

Click on you user Icon in the top right part for Github website or Github enterprise server, Go to settings.

<img src="assets/images/settings.png" alt="Settings" width="20%" height="20%">

Go to "Developer settings" page.

<img src="assets/images/developer%20settings.png" alt="Developer settings" width="20%" height="20%">

Then go to "Personal access tokens" page

<img src="assets/images/personal%20access%20tokens.png" alt="Personal access tokens" width="20%" height="20%">

and click on "Generate new token"

<img src="assets/images/generate%20new%20token.png" alt="Generate new token" width="50%">

Enter your password in newly opened login screen.

On successful login Personal access tokens page will be updated with available scopes. Add description for the token, tick on a "notifications" scope and click "Generate token".

<img src="assets/images/generate%20token.png" alt="Generate token" width="50%" height="50%">

You will see the value of the generated token. Copy the value and you have it.

**Note that once you will close the page you cannot fetch the value again.**

If you didn't configure the value with github notifier you can either generated new token or click on the existing token and push "Regenerate token button". When you regenerate the token make sure that applications and services don't use the old value of the token, because the old will become invalid.

# Comparison to other tools and techniques

**Disclaimer!** This is not definitive comparison with all the available tools. The comparison is done with the main popular tools. The opinions can be subjective. The whole idea of the section is to help users to choose the tools which best suits to their needs.

## Notifier for GitHub

The Chrome extension supports Github and Github enterprise server. However, you can enable only one Github Enterprise server or github.com account. As is shown in the screenshot the extension shows the repository name, Pull request/Issue name and why the notifications is shown. After clicking on the extension you will go to the Pull request/Issue.

<img src="assets/images/Notifier%20for%20GitHub%20Chrome%20extension%20notification.png" alt="Notifier for GitHub">

## RSS Notifications from github

Users can enable RSS feeds from github.com or Github Enterprise server by clicking to "Subscribe to your news feed" as shown below. Users need to know that RSS will push exact same things that users will see in their Github or Github Enterprise home page. This notifications will not include Issue/Pull Request events like opened, closed, merged (only for Pull requests) and comments.

<img src="assets/images/Enable%20RSS%20Notifications.png" alt="Enable RSS Notifications" width="45%" height="45%">

Then you can install one of the RSS feed notifier browser extension or a desktop application and get the notification popups

<img src="assets/images/RSS%20feed%20notification.png" alt="RSS Notifications">

## Octobox

[Octobox](https://github.com/octobox/octobox) is impressive tool for github.com accounts. It does not show notifications popups but it keeps the history of all notifications in github in well organized and user friendly way. One can say that [github-notifier](https://github.com/sargsyan/github-notifier) and [Octobox](https://github.com/octobox/octobox) can be used together, one of real time notifications and the other for the history.

# Configurations

The application is designed to run for multiple github instances on the same time.One instance is github.com the others are github enterprise instances.
Generally you will need to have one or two configurations. You can list, create, remove, activate and deactivate configurations. to get the help for configure.sh just run.

```sh
./configure.sh
````

# Testing

If something is not working in your system and you are sure that configurations are correct you can run unit tests for your system to see if system behaves correctly. For this you need to install test framework shell scripts and run unit tests locally

```sh
brew install shunit2
make test
```

# Troubleshooting

To check the daemon logs for the error use

```sh
tail -f /var/log/system.log
```

if the system logs tell that the application keeps exiting with non-zero exit codes, you can check the service logs in the **~/Library/Logs/github_notif/service.log** file or locate github_notif folder in Mac OSX Console application.

# Support
in case of problems, you can [create an issue](https://github.com/sargsyan/github-notifier/issues)
