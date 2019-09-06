[![Build Status](https://travis-ci.org/jcraigk/phishin-chatbot.svg?branch=master)](https://travis-ci.org/jcraigk/phishin-chatbot)
[![Maintainability](https://api.codeclimate.com/v1/badges/278d4695252307434304/maintainability)](https://codeclimate.com/github/jcraigk/phishin-chatbot/maintainability)
[![CodeCov](https://codecov.io/gh/jcraigk/phishin-chatbot/branch/master/graph/badge.svg)](https://codecov.io/gh/jcraigk/phishin-chatbot)

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

You'll need to expose the OAuth callback routes to the public Internet.  We recommend using [ngrok](https://ngrok.com/) to expose your local port 3000 to public port 80.  Once you have your external address, place it in `.env`:

```
OAUTH_CALLBACK_HOST=<your-host>
```

## Test Bot Setup

You'll need to create Slack and/or Discord bots to be used for manual testing during development.  You should name the bots something like "[Your Name] Test Bot".

Setup the OAuth redirect URI on each bot to be `https://<your-ngrok-domain>/oauth/slack` or `https://<your-ngrok-domain>/oauth/discord` depending on the platform.

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

You may choose to run both the app and services (Postgres and Redis) on your local machine without using Docker at all.  However, it is recommended that you use Docker for at least the services.  You may then run the Rails app on your local machine or in its Docker container.

You must create the local file `.env` if it does not already exist.  Inside, append the following:

```
REDIS_URL=redis://redis:6379
```

To start everything in Docker, run `make start` to build and start the Docker images.

Alternatively, you can run `make services` to run only Postgres and Redis in Docker to speed up development/debugging on the Rails side.  Then you can run Ruby/Rails directly on your own machine by running `bundle install` and `rails s` etc.  Note that you'll also need to manually initialize the database by running `rails db:create` and `rails db:migrate` (be sure to use `NOSOCKETS=true` as described below).

Once the stack is running, you can visit `localhost:3000` in your browser to see the dashboard. Assuming you setup your bots correctly as described above, you can use the buttons on the dashboard to register your development instance with your Slack team or Discord guild.

In addition to the web server, websockets are opened automatically to both Slack and Discord when the app boots.  To prevent duplicate sockets from opening, you'll want to use the environment variable `NOSOCKETS=true` when running Rails commands, such as `rails c`.

## Maintenance

The following cron job should be setup on the server to run daily:

```
curl POST https://chatbot.phish.in/teams/purge_inactive
```
