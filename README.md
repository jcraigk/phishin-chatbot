[![codecov](https://codecov.io/gh/jcraigk/phishin-chatbot/branch/master/graph/badge.svg)](https://codecov.io/gh/jcraigk/phishin-chatbot)
[![Maintainability](https://api.codeclimate.com/v1/badges/278d4695252307434304/maintainability)](https://codeclimate.com/github/jcraigk/phishin-chatbot/maintainability)

![Phish.in' Chatbot Logo](https://i.imgur.com/mxOqj0B.png)

The Phish.in' Chatbot is another way to interact with the [Phish.in' API](https://phish.in/api-docs), which is also an [open source project](https://github.com/jcraigk/phishin).

Currently, Slack and Discord are supported.  Other platforms may be supported in the future.

The production instance of this chatbot is hosted at [chatbot.phish.in](https://chatbot.phish.in).

Join the [Discord](https://discord.gg/KZWFsNN) to discuss development.

# Development

## App Stack

This is a Dockerized Rails project that uses Postgres and Redis for storage.  A Makefile is provided for easy container management.

## Phishin' API Key

In order to fetch data from the [Phishin' API](http://phish.in/api-docs), you'll need to obtain a key.  Please [email the maintainers](http://phish.in/contact) to request one.  Once you have it, place it in your local `.env` file:

```
PHISHIN_API_KEY=<your-key>
```

## OAuth Webhook Exposure

You'll need to expose the OAuth callback routes to the public Internet.  We recommend using [ngrok](https://ngrok.com/) to expose your local port 3000 to public port 80.  Once you've get the tunnel setup, set the following variables in your local `.env` file:

```
DISCORD_REDIRECT_URI=https://<your-ngrok-domain>/oauth/discord
SLACK_REDIRECT_URI=https://<your-ngrok-domain>/oauth/slack
```

## Test Bot Setup

You'll need to create Slack and/or Discord bots to be used for manual testing during development.  You should name the bots something like "[Your Name] Test Bot".

Once your bots are created, grab the following values and place them in your local `.env` file.

For Slack:

```
SLACK_APP_ID=<your-app-id>
SLACK_CLIENT_ID=<your-client-id>
SLACK_CLIENT_SECRET=<your-client-secret>
```

For Discord:

```
DISCORD_BOT_TOKEN=<your-bot-token>
DISCORD_CLIENT_ID=<your-client-id>
DISCORD_CLIENT_SECRET=<your-client-secret>
```

## Running the App

Run `make start` to build and start the Docker images.  Once running, can visit `localhost:3000` in your browser to see the dashboard.  Assuming you setup your bots correctly as described above, you can use the buttons on the dashboard to register your development instance with your Slack team or Discord guild.

In addition to the web stack, websockets are opened automatically to both Slack and Discord.  To prevent duplicate sockets from opening, you'll want to use the environment variable `NOSOCKETS=true` when running Rails commands, such as `rails c`.

## Maintenance

The following cron job should be setup on the server to run daily:

```
curl POST https://chatbot.phish.in/teams/purge_inactive
```
