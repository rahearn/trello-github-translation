# frozen_string_literal: true

require "json"

class TrelloExport
  attr_reader :json
  def initialize(filename)
    @json = JSON.parse(File.read(filename))
  end

  def lists
    @lists ||= Hash.new.tap do |lists|
      json["lists"].each do |l|
        lists[l["id"]] = l
      end
    end
  end

  def skipped_list_ids
    @skipped_list_ids ||= json["lists"].select { |l| ["DONE 🎉", "Delivered"].include?(l["name"]) }.map { |l| l["id"] }
  end

  def actions
    @actions ||= begin
      actions = Hash.new { |h, k| h[k] = [] }
      json["actions"].each do |a|
        next if a["data"]["card"].nil?
        actions[a["data"]["card"]["id"]] << a
      end
      actions
    end
  end

  def cards
    @cards ||= json["cards"].select { |c| !c["closed"] && !skipped_list_ids.include?(c["idList"]) }
  end

  def stories
    @stories ||= cards.map { |card| Story.new(card, actions[card["id"]], lists[card["idList"]]) }
  end
end

class Story
  attr_reader :card, :actions, :list
  def initialize(card, actions, list)
    @card = card
    @actions = actions
    @list = list
  end

  def title
    card["name"]
  end

  def body
    [
      card["desc"],
      comments
    ].compact.join("\n\n")
  end

  def labels
    card["labels"].map { |l| l["name"] }.push(list["name"]).join(",")
  end

  def comments
    comments = actions.select { |a| a["type"] == "commentCard" || a["type"] == "copyCommentCard" }.map do |a|
      "**#{a["memberCreator"]["username"]}:** *(#{a["date"]})*\n#{a["data"]["text"]}"
    end.reverse
    if comments.count > 0
      <<~EOC
        ### Comments

        #{comments.join("\n\n")}
      EOC
    end
  end

  def attachments
    actions.select { |a| a["type"] == "addAttachmentToCard" }
  end
end
