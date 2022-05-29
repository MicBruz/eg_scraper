require 'get_data'

class ScrapersController < ApplicationController
  def home
    @number_of_mens_fragrances = FilteredBySex.last.male
    @number_of_unisex_fragrances = FilteredBySex.last.unisex
    @last_pull = FilteredBySex.last_pull
    @previous_pull = FilteredBySex.previous_pull
    @change_male = FilteredBySex.difference_to_previous_pull("male")
    @change_unisex = FilteredBySex.difference_to_previous_pull("unisex")
  end

  def get_items
    @testing = GetData.get_items
  end
end
