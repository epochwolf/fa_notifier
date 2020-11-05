# FA Notifier

## Goal

Fur Affinity lacks any support for notification by email. This is particularly bad with its internal messaging system (notes). For someone who doesn't check the site every day, notes can sit for days without a response. This project exists to fill that gap.

## Assumptions

* You have an email account that the [mailer gem](https://github.com/mikel/mail) supports.
* You're using an email client that supports CSS2 stylesheets in the `<head>` tag. (e.g. Apple Mail)<sup>1</sup>.
* You know the following:
  * Working with ruby projects.
  * Extracting cookies using the Web inspector
  * Configuring SMTP
  * Setting up cron jobs

## Installation

This is a standard ruby project. I recommend using RVM or another ruby version manager but this is not required.

1. Checkout the repository and run bundle install under the ruby version specified in `.ruby-version`.
2. Copy `settings.yml.example` to `settings.yml` and configure accordingly.
3. Configure your Fur Affinity account.
  * On the "Site Settings" page, you need to set "Date Format" to "Full date format" (Otherwise... there be dragons<sup>2</sup>)
4. Test configuration.
  1. Run `rake download` to verify the script can log in
  2. Run `rake read` to verify the downloaded files
  3. Run `rake send_test` to ensure email delivery
  4. Run `rake send` to send your first summary email.
  5. Run `reset_data` so send_new doesn't hammer Fur Affinity and your email by sending *EVERYTHING* it hasn't seen before.
5. Configure cron jobs.

### Example Cron configuration.

This is my personal configuration. I highly recommend not setting send_new to run more than once per hour.

*NOTE: `bin/cron` assumes you are running on Ubuntu with the `rvm` package installed. You may need to edit the file or write your own script.*

```cron
30 7 * * * /home/epochwolf/Projects/fa_notifier/bin/cron send
0 8-21 * * * /home/epochwolf/Projects/fa_notifier/bin/cron send_new
```

## Authors

* [Epoch Wolf](https://github.com/epochwolf)

## Footnotes

1. I have only tested this project with Apple Mail, which uses webkit for rendering. According to [Campaign Monitor](https://www.campaignmonitor.com/css/style-element/style-in-head/) most clients should work. A side note, HTML email is the kind of nightmare that D&D 5E Warlocks have as Patrons<sup>3</sup>.
2. Not the fun kind of dragons.
3. The D&D 5E Player's Handbook has Archfey, Fiend, Great Old One, and Microsoft<sup>4</sup> as options.
4. Okay, Microsoft isn't an option, but it should be.
