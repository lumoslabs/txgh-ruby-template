Txgh Ruby Template  &nbsp; [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
====

The Txgh Ruby template is a quick way to get up-and-running with [Txgh](https://github.com/lumoslabs/txgh). It includes a number of handy rake tasks and a configuration wizard.

What is Txgh?
---

Txgh is a localization automation service. It connects Transifex, a 3rd-party translation management tool, with Github. By watching your repository for changes to translatable content, Txgh is able to automatically push content to Transifex for translation and pull translated content back into your repository. It uses Github and Transifex webhooks along with a bunch of API calls to work its magic.

Getting Started
---

1. Clone this repository.

2. Change directory into your local clone and run `bundle install`.

3. Configure Txgh by running `./bin/configure` or `bundle exec rake configure`. Follow the script's instructions. See the [Txgh README](https://github.com/lumoslabs/txgh#configuring-txgh) for a description of all the configuration options.

4. Run `bundle exec rake run`. Txgh should start on port 9292.

5. Test your running instance by hitting the `health_check` endpoint, eg `curl -v localhost:9292/health_check`. You should get an HTTP 200 response.

Rake Tasks
---

* **`configure`**: Walks you through connecting a Transifex project and a Github repo. In other words, adds to or modifies entries in `./config.yml`.
* **`run`**: Starts Txgh (not as a daemon).
* **`start`**: Starts Txgh as a daemon. Process id will be stored in `./txgh.pid`.
* **`stop`**: Stops a running Txgh daemon.
* **`status`**: Determines if a Txgh daemon is running or not.

Requirements
---

You'll need an Internet connection. Other than that, Txgh has no external requirements like a database or cache.

Authors
---

This repository is maintained by [Cameron Dutro](https://github.com/camertron) from Lumos Labs.

License
---

Licensed under the Apache License, Version 2.0. See the LICENSE file included in this repository for the full text.
