# How to generate github notifications token

Click on you user Icon in the top right part for Github website or Github enterprise server, Go to settings.

<img src="settings.png" alt="Settings" width="20%" height="20%">

Go to "Developer settings" page.

<img src="developer%20settings.png" alt="Developer settings" width="20%" height="20%">

Then go to "Personal access tokens" page

<img src="personal%20access%20tokens.png" alt="Personal access tokens" width="20%" height="20%">

and click on "Generate new token"

<img src="generate%20new%20token.png" alt="Generate new token" width="50%">

Enter your password in newly opened login screen.

On successful login Personal access tokens page will be updated with available scopes. Add description for the token, tick on a "notifications" scope and click "Generate token".

<img src="generate%20token.png" alt="Generate token" width="50%" height="50%">

You will see the value of the generated token. Copy the value and you have it.

**Note that once you will close the page you cannot fetch the value again.**

If you didn't configure the value with github notifier you can either generated new token or click on the existing token and push "Regenerate token button". When you regenerate the token make sure that applications and services don't use the old value of the token, because the old will become invalid.
