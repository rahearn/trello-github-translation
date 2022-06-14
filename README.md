Trello -> Github Issues
=======================

Simple script for reading a Trello JSON export and creating Github Issues from them

Usage
-----

`./process.rb` will read `trello.json` and create issues in Github. It will also flag any stories that include attachments.

### Configuration

The following Environment variables must be set to run the script:

* `GITHUB_REPO`: github repository in `owner/repo` format
* `GITHUB_TOKEN`: your personal access token as created at https://github.com/settings/tokens
* `SKIP_LIST_NAMES`: optional - comma delimited list of trello columns to not include as new issues. Case insensitive. Default: "done 🎉,delivered"
* `SLEEP_INTERVAL`: optional - number of seconds to sleep between story creation call, to avoid rate limiting issues. Default: 20 seconds
* `TRELLO_FILENAME`: optional - the name of the trello export file. Default: `trello.json`
