import os
import ospaths
import httpclient
import json
import times
import uri
import strutils

const 
    SlackApiTokenEnvironmentVariable = "SLACK_API_TOKEN"
    SlackApiEmojiEndpoint = "https://slack.com/api/emoji.list"
    TimestampFormat = "yyyyMMddhhmmss"

proc download_images(token: string) =
    let client = newHttpClient()
    
    client.headers = newHttpHeaders([
        ("Content-Type", "application/json"),
        ("Authorization", "Bearer " & token)
    ])
    let emoji_data = parseJson(client.getContent(SlackApiEmojiEndpoint))

    let dateFolder = format(getLocalTime(getTime()), TimestampFormat)

    let _ = existsOrCreateDir(dateFolder)

    for item in emoji_data["emoji"].pairs:
        let imageUrl = item.val.getStr
        if not imageUrl.contains("alias:"):
            let imageExt = imageUrl.splitPath().tail.splitFile().ext
            echo "Downloading \"$1\" as $2" % [item.key, item.key & imageExt]
            client.downloadFile(imageUrl,  joinPath(dateFolder, item.key & imageExt))

proc main() =
    if existsEnv(SlackApiTokenEnvironmentVariable):
        download_images(getEnv(SlackApiTokenEnvironmentVariable))
    else:
        echo "Environment variable \"$1\" isn't set" % [SlackApiTokenEnvironmentVariable]

if isMainModule:
    main()
