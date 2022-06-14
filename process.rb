#!/usr/bin/env ruby

require_relative "trello_export"
require_relative "github_import"

export = TrelloExport.new(ENV.fetch("TRELLO_FILENAME", "trello.json"))
GithubImport.new(export.stories).run
puts "Import to github complete"

export.stories.each do |story|
  if story.attachments.count > 0
    puts "#{story.card["shortUrl"]} has attachments. Manually copy them over to Github"
  end
end
