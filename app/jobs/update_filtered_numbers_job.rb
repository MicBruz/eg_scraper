class UpdateFilteredNumbersJob
  include Sidekiq::Job

  def perform
    controller = FilteredBySexController.new
    controller.refresh_numbers_for_job
  end
end
