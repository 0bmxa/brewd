# `brewd`

`brewd` is a small [HomeBrew](https://brew.sh/) daemon, which keeps your Brew
installation up to date by running `brew update` for you in the background. It
also lets you know you if any of your packages are outdated via macOS
notifications.

## Installation/Running

Sadly, there is no installer right now, so you have to build and install it
yourself:
```
xcodebuild -configuration Release DEVELOPMENT_TEAM='XYZ1234567'
cp ./.build/brewd /usr/local/bin/
rm -rf ./.build
```
Then just run it from your shell with
```
brewd
```

Note: You need to have Xcode installed for building.


## To Do

- Tests!
- Create some installer and `launchd` job.
- Make use of some HomeBrew API instead of running the executable
- …


### Disclaimer
This is very beta work in progress and might have (severe?) security, usability
or other issues. Use at your own risk.
