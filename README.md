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
* `TRELLO_FILENAME`: optional - the name of the trello export. Default: `trello.json`
