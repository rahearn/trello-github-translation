# frozen_string_literal: true

require "octokit"

class GithubImport
  attr_reader :stories
  def initialize(stories)
    @stories = stories
  end

  def run
    login
    stories.each do |story|
      puts "Creating issue for #{story.title}"
      client.create_issue(ENV["GITHUB_REPO"], story.title, story.body, labels: story.labels)
      sleep ENV.fetch("SLEEP_INTERVAL", 20).to_i
    end
  end

  private

  def client
    @client ||= Octokit::Client.new access_token: ENV["GITHUB_TOKEN"]
  end

  def login
    client.user.login
  end
end
