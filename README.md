# check-aur-pkg-version
Compare version of AUR package, which are maintained by given maintainer, with upstream on GitHub.

Using systemd user service and timer (available by adding `--user` to `systemctl`), result of version comparison will be posted everyday at 12:00.

## Usage:
See `python check-aur-pkg-version --help`:

```
$ check-aur-pkg-version ./check-aur-pkg-version --help
Compare version of AUR package, which are maintained by given maintainer,
with upstream on GitHub

Usage:
    check_aur_pkg_version MAINTAINER [--slack-webhook-url WEBHOOK_URL]
    check_aur_pkg_version -c CONFIG

Arguments:
    MAINTAINER                         AUR package maintainer

Options:
    --slack-webhook-url WEBHOOK_URL    Slack incoming webhook URL
                                       to post message of comparation
                                       result
    -c CONFIG                          Specify config instead of passing
                                       maintainer and webhook URL directly
```

## Install
Write `config.yaml` based on `config.yaml.tmpl`, then invoke below:
```
$ make
$ systemctl --user start check-aur-pkg-version.timer
```

## Uninstall
```
$ make uninstall
$ make clean
```
