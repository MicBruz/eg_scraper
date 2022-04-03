class FilteredBySexController < ApplicationController

  def refresh_numbers
    call_elnino_api

    @number_of_mens_fragrances = @current_fragrances_number[0]['count']
    @number_of_unisex_fragrances = @current_fragrances_number[2]['count']

    new_numbers = FilteredBySex.new(male: @number_of_mens_fragrances, unisex: @number_of_unisex_fragrances)

    if new_numbers.save
      flash[:notice] = "Successfuly refreshed."
    else
      flash[:alert] = "Something went wrong: #{new_numbers.errors}"
    end

    redirect_back(fallback_location: root_path)
  end

end
