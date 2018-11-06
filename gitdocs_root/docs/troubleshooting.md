# Troubleshooting

To check the daemon logs for the error use

```sh
tail -f /var/log/system.log
```

if the system logs tell that the application keeps exiting with non-zero exit codes, you can check the service logs in the **~/Library/Logs/github_notif/service.log** file or locate github_notif folder in Mac OSX Console application.
