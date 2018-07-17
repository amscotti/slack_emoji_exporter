import
  httpclient, json, os, ospaths, strformat, strutils, times, uri

const
  SlackApiTokenEnvironmentVariable = "SLACK_API_TOKEN"
  SlackApiEmojiEndpoint = "https://slack.com/api/emoji.list"
  TimestampFormat = "yyyyMMddhhmmss"

proc downloadImages(token: string) =
  let client = newHttpClient()
    
  client.headers = newHttpHeaders([
    ("Content-Type", "application/json"),
    ("Authorization", fmt"Bearer {token}")
  ])
  let emojiData = client.getContent(SlackApiEmojiEndpoint).parseJson()

  let dateFolder = local(getTime()).format(TimestampFormat)
  let outputPath = joinPath("output", dateFolder)

  createDir(outputPath)

  for item in emojiData["emoji"].pairs:
    let imageUrl = item.val.getStr
    if not imageUrl.contains("alias:"):
      let imageExt = imageUrl.splitPath().tail.splitFile().ext
      echo fmt"Downloading '{item.key}' as {item.key & imageExt}"
      client.downloadFile(imageUrl, joinPath(outputPath, item.key & imageExt))

proc main() =
  if existsEnv(SlackApiTokenEnvironmentVariable):
    downloadImages(getEnv(SlackApiTokenEnvironmentVariable))
  else:
    echo fmt"Environment variable {SlackApiTokenEnvironmentVariable} isn't set"

if isMainModule:
  main()
