class FilteredBySexController < ApplicationController
  
  def self.home
    # call_elnino_api
    # @number_of_mens_fragrances = @current_fragrances_number[0]['count']
    # @number_of_unisex_fragrances = @current_fragrances_number[2]['count']
    #
    # for testing purposes not to call API
    @number_of_mens_fragrances = 100
    @number_of_unisex_fragrances = 150
    @date = DateTime.now.strftime("%d.%m.%Y %H:%M")

    new_record = FilteredBySexController.new(@number_of_mens_fragrances, @number_of_unisex_fragrances)
    new_record.save
  end

  
end
