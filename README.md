# Slack Emoji Exporter
A tool to export Slack Workspace's Emojis

## To Build
* Install Nim v1.8.0
* Run `nimble build`

## To Run
* Create an API tokens for Slack from the [Legacy Tokens page](https://api.slack.com/custom-integrations/legacy-tokens)
* `SLACK_API_TOKEN=xoxp-XXXXXX ./slack_emoji_exporter`

## Docker
There is an docker image you can use for you don't need to build the code yourself,
`docker run -e SLACK_API_TOKEN=xoxp-XXXXXX -v ~/emojis:/root/output amscotti/slack_emoji_exporter`