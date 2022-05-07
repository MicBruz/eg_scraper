class UpdateFilteredNumbersJob < ApplicationJob
  queue_as :default

  def perform
    controller = FilteredBySexController.new
    controller.refresh_numbers_for_job
  end
end
