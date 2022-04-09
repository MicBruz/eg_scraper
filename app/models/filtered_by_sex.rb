class FilteredBySex < ApplicationRecord

  private

  def self.last_pull
    last_pull = last.created_at.localtime
    last_pull_time = last_pull.strftime("%H:%M:%S")
    last_pull_date = (last_pull.today? ? "Today" : last_pull.strftime("%d.%m.%y"))

    { time: last_pull_time, date: last_pull_date }
  end

  def self.previous_pull
    ((last.created_at - second_to_last.created_at) / 60).round
  end

  def self.difference_to_previous_pull(sex)
    sex == "male" ? last.male - second_to_last.male : last.unisex - second_to_last.unisex
  end
end
