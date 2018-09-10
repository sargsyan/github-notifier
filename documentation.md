Documentation

## Table of Contents

- [Description](#description)
- [Tips and tricks](#how-to-use)
- [Installing](#installing)
- [Comparison to with other tools](#others)
- [How to generate github notifications token](#how-to-generate-github-notifications-token)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

# Description

The application will show real-time notifications from Github and Github enterprise instances. One of the most important focuses of the application is to provide the most information with the notification banner, so that users would not need to click and open the details in a browser unless they want to participate in the thread. This will allow users to get updated on what is going on in the projects that they are interested without getting interupted from their daily tasks.

# How to generate github notifications token

Click on you user Icon in the top right part for Github website or Github enterprise server, Go to settings.

![settings](https://github.com/sargsyan/github-notifier/blob/gh-pages/assets/images/settings.png)

Go to "Developer settings" page.

![Developer settings](https://github.com/sargsyan/github-notifier/blob/gh-pages/assets/images/developer%20settings.png)

Then go to "Personal access tokens" page

![Personal access tokens](https://github.com/sargsyan/github-notifier/blob/gh-pages/assets/images/personal%20access%20tokens.png)

and click on "Generate new token"

![Generate new token](https://github.com/sargsyan/github-notifier/blob/gh-pages/assets/images/generate%20new%20token.png)

Enter your password in newly opened login screen.

On successful login Personal access tokens page will be updated with available scopes. Add description for the token, tick on a "notifications" scope and click "Generate token".

![Generate token](https://github.com/sargsyan/github-notifier/blob/gh-pages/assets/images/generate%20token.png)

You will see the value of the generated token. Copy the value and you have it.

**Note that once you will close the page you cannot fetch the value again.** 

If you didn't configure the value with github notifier you can either generated new token or click on the existing token and push "Regenerate token button". When you regenerate the token make sure that applications and services don't use the old value of the token, because the old will become invalid.

# Comparison to with other tools

# Support
in case of problems, you can [create an issue](https://github.com/sargsyan/github-notifier/issues) 
