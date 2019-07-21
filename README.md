[![codecov](https://codecov.io/gh/jcraigk/phishin-chatbot/branch/master/graph/badge.svg)](https://codecov.io/gh/jcraigk/phishin-chatbot)
[![Maintainability](https://api.codeclimate.com/v1/badges/278d4695252307434304/maintainability)](https://codeclimate.com/github/jcraigk/phishin-chatbot/maintainability)

![Phish.in' Chatbot Logo](https://i.imgur.com/mxOqj0B.png)

The Phish.in' Chatbot is another way to interact with the [Phish.in' API](https://phish.in/api-docs), which is also an [open source project](https://github.com/jcraigk/phishin).

The production instance of this chatbot is hosted at [chatbot.phish.in](https://chatbot.phish.in), which will eventually provide a means of integrating with your team's Slack or Discord.

Join the [Discord](https://discord.gg/KZWFsNN) to discuss development.

# TODO development section about registering bots and .env file and ngrok

The following cron job should be setup on the server to run daily:

```
curl POST https://chatbot.phish.in/teams/purge_inactive
```
