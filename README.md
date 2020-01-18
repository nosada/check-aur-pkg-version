# check-aur-pkg-version
Compare version of AUR package, which are maintained by given maintainer, with upstream on GitHub.

## Usage:
See `python check-aur-pkg-version --help`:

```
$ check-aur-pkg-version ./check-aur-pkg-version --help
Compare version of AUR package, which are maintained by given maintainer,
with upstream on GitHub

Usage:
    check_aur_pkg_version [MAINTAINER] [--slack-webhook-url SLACK_WEBHOOK_URL]
    check_aur_pkg_version [-c CONFIG]

Arguments:
    MAINTAINER                         AUR package maintainer

Options:
    --slack-webhook-url SLACK_WEBHOOK_URL    Slack incoming webhook URL
                                             to post message of comparation
                                             result
    -c CONFIG                                Specify config instead of passing
                                             maintainer and webhook URL
                                             directly

Notes:
    MAINTAINER and SLACK_WEBHOOK_URL can be passed as environment variables.
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
