# slack_upload plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-slack_upload)


This plugin simply uploads a given file to your Slack. 

Sometimes as part of CI builds you want to generate some files from the project that might be valuable for your team. You can think about documentation or screenshots of the application on different devices. With `slack_uplaod` it's easy to send them to dedicated `Slack` channel or directly to your teammates. 

Note: `Fastlane` comes with `slack` plugin by default, although it uses `slack-notifier` API that doesn't support uploading files.

## Getting Started

1. Generate `Slack token` for `Fastlane` bot
    - From your Slack organization page, go to `Manage` -> `Custom Integrations`
    - Open `Bots`
    - Add Configuration
    - Choose a name for your bot, e.g. `"fastlane"`
    - Save `API Token`

2. Add plugin to `fastlane`

```bash
fastlane add_plugin slack_upload
```

3. Add `slack_upload` to your lane in `Fastfile` whenever you want to upload the file

In the following example we generate screenshots ([More info](https://docs.fastlane.tools/getting-started/ios/screenshots/)) and send them to `#general` channel

```bash
lane :screenshots_lane do

    version = get_version_number

    # Generate screenshots
    capture_screenshots

    # Zip screenshots folder
    zip(
      path: "./fastlane/screenshots",
      output_path: "./fastlane/screenshots.zip"
    )

    # Upload to slack
    slack_upload(
            slack_api_token: "xyz", # Preferably configure as ENV['SLACK_API_TOKEN']
            title: "New version #{version} is available ",
            channel: "#general",
            file_path: "./fastlane/screenshots.zip",
            initial_comment: "Changelog goes here"
    ) 
  end
```


## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).