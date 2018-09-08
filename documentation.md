Documentation

## Table of Contents

- [Description](#description)
- [Tips and tricks](#how-to-use)
- [Installing](#installing)
- [Comparison to with other tools](#others)
- [How to generate github notifications token](#how-to-generate-github-notifications-token)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

# How to generate github notifications token

Click on you user Icon in the top right part for github.com website or github enterprise server, Go to settings.

Go to "Developer settings" page. Then go to "Personal access tokens" page an click on "Generate new token". Enter your password in newly opened login screen.

On successful login Personal access tokens page will be updated with available scopes. Add description for the token, tick on a "notifications" scope and click "Generate token".

You will see the value of the generated token. Copy the value and you have it

## Note that once you will close the page you cannot fetch the value again. 

If you didn't configure the value with github notifier you can either generated new token or click on the existing token and push "Regenerate token button". When you regenerate the token make sure that applications and services don't use the old value of the token, because the old will become invalid.
