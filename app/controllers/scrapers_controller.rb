require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class ScrapersController < ApplicationController

  def home
    @number_of_mens_fragrances = FilteredBySex.last.male
    @number_of_unisex_fragrances = FilteredBySex.last.unisex

    @last_pull = FilteredBySex.last.created_at if FilteredBySex.last.present?
  end

  def get_items
    # for testing purposes not to call API
    return @testing = {"Calvin Klein Women wody perfumowane dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>132.09, :url=>"www.e-glamour.pl/calvin-klein-women-woda-perfumowana-dla-kobiet-100-ml/"}, {:variant_name=>"50 ml", :variant_price=>105.4, :url=>"www.e-glamour.pl/calvin-klein-women-woda-perfumowana-dla-kobiet-50-ml/"}, {:variant_name=>"10 ml", :variant_price=>38.4, :url=>"www.e-glamour.pl/calvin-klein-women-woda-perfumowana-dla-kobiet-10-ml/"}, {:variant_name=>"Zestaw", :variant_price=>130.25, :url=>"www.e-glamour.pl/calvin-klein-women-zestaw-dla-kobiet-edp-30-ml-mleczko-do-ciala-100-ml/"}], "Mexx Woman wody perfumowane dla kobiet"=>[{:variant_name=>"40 ml", :variant_price=>55.2, :url=>"www.e-glamour.pl/mexx-woman-woda-perfumowana-dla-kobiet-40-ml/"}, {:variant_name=>"20 ml", :variant_price=>43.69, :url=>"www.e-glamour.pl/mexx-woman-woda-perfumowana-dla-kobiet-20-ml/"}], "David Beckham Intimately Men wody toaletowe dla mężczyzn"=>[{:variant_name=>"75 ml", :variant_price=>41.99, :url=>"www.e-glamour.pl/david-beckham-intimately-men-woda-toaletowa-dla-mezczyzn-75-ml/"}, {:variant_name=>"30 ml", :variant_price=>35.9, :url=>"www.e-glamour.pl/david-beckham-intimately-men-woda-toaletowa-dla-mezczyzn-30-ml/"}], "Antonio Banderas Blue Seduction For Men wody toaletowe dla mężczyzn"=>[{:variant_name=>"100 ml", :variant_price=>60.1, :url=>"www.e-glamour.pl/antonio-banderas-blue-seduction-for-men-woda-toaletowa-dla-mezczyzn-100-ml/"}, {:variant_name=>"100 ml tester", :variant_price=>51.1, :url=>"www.e-glamour.pl/antonio-banderas-blue-seduction-for-men-woda-toaletowa-dla-mezczyzn-100-ml-tester/"}, {:variant_name=>"50 ml", :variant_price=>48.2, :url=>"www.e-glamour.pl/antonio-banderas-blue-seduction-for-men-woda-toaletowa-dla-mezczyzn-50-ml/"}], "Mexx Festival Splashes wody toaletowe dla mężczyzn"=>[{:variant_name=>"50 ml", :variant_price=>26.9, :url=>"www.e-glamour.pl/mexx-festival-splashes-woda-toaletowa-dla-mezczyzn-50-ml/"}, {:variant_name=>"30 ml", :variant_price=>22.5, :url=>"www.e-glamour.pl/mexx-festival-splashes-woda-toaletowa-dla-mezczyzn-30-ml/"}], "Gabriela Sabatini Miss Gabriela wody toaletowe dla kobiet"=>[{:variant_name=>"30 ml", :variant_price=>28.6, :url=>"www.e-glamour.pl/gabriela-sabatini-miss-gabriela-woda-toaletowa-dla-kobiet-30-ml/"}, {:variant_name=>"20 ml", :variant_price=>25, :url=>"www.e-glamour.pl/gabriela-sabatini-miss-gabriela-woda-toaletowa-dla-kobiet-20-ml/"}], "Zadig & Voltaire This is Her! 100 ml woda perfumowana tester dla kobiet"=>[], "David Beckham Instinct wody toaletowe dla mężczyzn"=>[{:variant_name=>"75 ml", :variant_price=>44, :url=>"www.e-glamour.pl/david-beckham-instinct-woda-toaletowa-dla-mezczyzn-75-ml/"}, {:variant_name=>"50 ml", :variant_price=>38.7, :url=>"www.e-glamour.pl/david-beckham-instinct-woda-toaletowa-dla-mezczyzn-50-ml/"}, {:variant_name=>"30 ml", :variant_price=>34.9, :url=>"www.e-glamour.pl/david-beckham-instinct-woda-toaletowa-dla-mezczyzn-30-ml/"}], "GUESS Seductive Noir 250 ml spray do ciała dla kobiet"=>[], "Jimmy Choo Jimmy Choo wody perfumowane dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>189.36, :url=>"www.e-glamour.pl/jimmy-choo-jimmy-choo-woda-perfumowana-dla-kobiet-100-ml/"}, {:variant_name=>"100 ml tester", :variant_price=>144.6, :url=>"www.e-glamour.pl/jimmy-choo-jimmy-choo-woda-perfumowana-dla-kobiet-100-ml-tester/"}, {:variant_name=>"40 ml", :variant_price=>101.57, :url=>"www.e-glamour.pl/jimmy-choo-jimmy-choo-woda-perfumowana-dla-kobiet-40-ml/"}, {:variant_name=>"4,5 ml", :variant_price=>30.5, :url=>"www.e-glamour.pl/jimmy-choo-jimmy-choo-woda-perfumowana-dla-kobiet-4-5-ml/"}], "Calvin Klein Escape 100 ml woda perfumowana dla kobiet"=>[], "Calvin Klein Obsession wody perfumowane dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>101.5, :url=>"www.e-glamour.pl/calvin-klein-obsession-woda-perfumowana-dla-kobiet-100-ml/"}, {:variant_name=>"30 ml", :variant_price=>71.6, :url=>"www.e-glamour.pl/calvin-klein-obsession-woda-perfumowana-dla-kobiet-30-ml/"}, {:variant_name=>"15 ml", :variant_price=>45.6, :url=>"www.e-glamour.pl/calvin-klein-obsession-woda-perfumowana-dla-kobiet-15-ml/"}], "Paco Rabanne Paco 100 ml woda toaletowa unisex"=>[], "Versace Blue Jeans Man wody toaletowe dla mężczyzn"=>[{:variant_name=>"75 ml", :variant_price=>68, :url=>"www.e-glamour.pl/versace-blue-jeans-man-woda-toaletowa-dla-mezczyzn-75-ml/"}, {:variant_name=>"75 ml tester", :variant_price=>67.7, :url=>"www.e-glamour.pl/versace-blue-jeans-man-woda-toaletowa-dla-mezczyzn-75-ml-tester/"}], "Moschino Funny! wody toaletowe dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>119.9, :url=>"www.e-glamour.pl/moschino-funny-woda-toaletowa-dla-kobiet-100-ml/"}, {:variant_name=>"4 ml", :variant_price=>25.1, :url=>"www.e-glamour.pl/moschino-funny-woda-toaletowa-dla-kobiet-4-ml/"}], "GUESS Seductive Homme wody toaletowe dla mężczyzn"=>[{:variant_name=>"100 ml", :variant_price=>68.31, :url=>"www.e-glamour.pl/guess-seductive-homme-woda-toaletowa-dla-mezczyzn-100-ml/"}, {:variant_name=>"50 ml", :variant_price=>81.2, :url=>"www.e-glamour.pl/guess-seductive-homme-woda-toaletowa-dla-mezczyzn-50-ml/"}, {:variant_name=>"Zestaw", :variant_price=>107.2, :url=>"www.e-glamour.pl/guess-seductive-homme-zestaw-dla-mezczyzn-edt-100-ml-dezodorant-226-ml/"}], "Bentley Bentley For Men Absolute 100 ml woda perfumowana dla mężczyzn"=>[], "Mexx Black wody toaletowe dla kobiet"=>[{:variant_name=>"30 ml", :variant_price=>39.7, :url=>"www.e-glamour.pl/mexx-black-woda-toaletowa-dla-kobiet-30-ml/"}, {:variant_name=>"15 ml", :variant_price=>34.8, :url=>"www.e-glamour.pl/mexx-black-woda-toaletowa-dla-kobiet-15-ml/"}], "Dolce&Gabbana Light Blue wody toaletowe dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>249.77, :url=>"www.e-glamour.pl/dolce-gabbana-light-blue-woda-toaletowa-dla-kobiet-100-ml/"}, {:variant_name=>"100 ml tester", :variant_price=>192.16, :url=>"www.e-glamour.pl/dolce-gabbana-light-blue-woda-toaletowa-dla-kobiet-100-ml-tester/"}, {:variant_name=>"25 ml", :variant_price=>136.34, :url=>"www.e-glamour.pl/dolce-gabbana-light-blue-woda-toaletowa-dla-kobiet-25-ml/"}, {:variant_name=>"Zestaw", :variant_price=>275.6, :url=>"www.e-glamour.pl/dolce-gabbana-light-blue-zestaw-dla-kobiet-edt-100-ml-mleczko-do-ciala-75-ml/"}], "Jaguar Classic Chromite wody toaletowe dla mężczyzn"=>[{:variant_name=>"100 ml tester", :variant_price=>40.7, :url=>"www.e-glamour.pl/jaguar-classic-chromite-woda-toaletowa-dla-mezczyzn-100-ml-tester/"}, {:variant_name=>"Zestaw", :variant_price=>76.8, :url=>"www.e-glamour.pl/jaguar-classic-chromite-zestaw-dla-mezczyzn-edt-100-ml-zel-pod-prysznic-200-ml/"}]}

    @items_sorted = {}
    call_elnino_api

    # n+1 issue
    @items_data[:items].each do |item|
      name_heureka = item['name_heureka']
      variants = []
      item['variants_in_stock']&.each do |var|
        variants << { variant_name: var['variantName'],
                      variant_price: var['price'],
                      url: ('www.e-glamour.pl' + var['curl']).to_s }
      end
      @items_sorted[name_heureka] = variants
    end
  end
  
  def refresh_numbers
    call_elnino_api

    @number_of_mens_fragrances = @current_fragrances_number[0]['count']
    @number_of_unisex_fragrances = @current_fragrances_number[2]['count']
    
    new_numbers = FilteredBySex.new(male: @number_of_mens_fragrances, unisex: @number_of_unisex_fragrances)
    new_numbers.save

    redirect_back(fallback_location: root_path)
  end

end
