require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class ScrapersController < ApplicationController
  def home; end

  def get_data

    url = URI('https://www.e-glamour.pl/services/stargate/product-list?c=613&f%5C%5Bsex%5C%5D%5C%5B%5C%5D=4&f%5C%5Bsex%5C%5D%5C%5B%5C%5D=5&page=3')

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request['authority'] = 'www.e-glamour.pl'
    request['sec-ch-ua'] = '" Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"'
    request['content-type'] = 'application/json'
    request['identity'] = '7bd163ade5decb7d34466b8b4cf9f0fc'
    request['sec-ch-ua-mobile'] = '?0'
    request['user-agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36'
    request['sec-ch-ua-platform'] = '"macOS"'
    request['instance'] = 'egpl'
    request['accept'] = '*/*'
    request['sec-fetch-site'] = 'same-origin'
    request['sec-fetch-mode'] = 'cors'
    request['sec-fetch-dest'] = 'empty'
    request['referer'] = 'https://www.e-glamour.pl/perfumy/?c=613&f[sex][]=4&page=2&f[sex][]=5'
    request['accept-language'] = 'pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7'
    request['cookie'] = 'visit_start=%7B%22referer%22:%22%22,%22time%22:1642865198278,%22url%22:%22https://www.e-glamour.pl/perfumy/?c=613&f%5Bsex%5D%5B%5D=4&page=2&f%5Bsex%5D%5B%5D=5%22%7D; identity=7bd163ade5decb7d34466b8b4cf9f0fc; PHPSESSID=7bd163ade5decb7d34466b8b4cf9f0fc; _gcl_au=1.1.1454671233.1642865200; percent_sale=0; _ga=GA1.2.1335135212.1642865200; _gid=GA1.2.933556858.1642865200; _dc_gtm_UA-6319024-1=1'

    response = http.request(request)
    response = JSON.parse(response.body)
    total_count = { total_count: response['total_count'] }
    data = { items: response['items'] }

    @items_sorted = {}

    # n+1 issue

    data[:items].each do |item|
      name_heureka = item['name_heureka']
      variants = []
      item['variants_in_stock']&.each do |var|
        variants << { variant_name: var['variantName'],
                      variant_price: var['price'],
                      url: (request['authority'] + var['curl']).to_s }
      end
      @items_sorted[name_heureka] = variants
    end

    @testing = {"Calvin Klein Women wody perfumowane dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>132.09, :url=>"www.e-glamour.pl/calvin-klein-women-woda-perfumowana-dla-kobiet-100-ml/"}, {:variant_name=>"50 ml", :variant_price=>105.4, :url=>"www.e-glamour.pl/calvin-klein-women-woda-perfumowana-dla-kobiet-50-ml/"}, {:variant_name=>"10 ml", :variant_price=>38.4, :url=>"www.e-glamour.pl/calvin-klein-women-woda-perfumowana-dla-kobiet-10-ml/"}, {:variant_name=>"Zestaw", :variant_price=>130.25, :url=>"www.e-glamour.pl/calvin-klein-women-zestaw-dla-kobiet-edp-30-ml-mleczko-do-ciala-100-ml/"}], "Mexx Woman wody perfumowane dla kobiet"=>[{:variant_name=>"40 ml", :variant_price=>55.2, :url=>"www.e-glamour.pl/mexx-woman-woda-perfumowana-dla-kobiet-40-ml/"}, {:variant_name=>"20 ml", :variant_price=>43.69, :url=>"www.e-glamour.pl/mexx-woman-woda-perfumowana-dla-kobiet-20-ml/"}], "David Beckham Intimately Men wody toaletowe dla mężczyzn"=>[{:variant_name=>"75 ml", :variant_price=>41.99, :url=>"www.e-glamour.pl/david-beckham-intimately-men-woda-toaletowa-dla-mezczyzn-75-ml/"}, {:variant_name=>"30 ml", :variant_price=>35.9, :url=>"www.e-glamour.pl/david-beckham-intimately-men-woda-toaletowa-dla-mezczyzn-30-ml/"}], "Antonio Banderas Blue Seduction For Men wody toaletowe dla mężczyzn"=>[{:variant_name=>"100 ml", :variant_price=>60.1, :url=>"www.e-glamour.pl/antonio-banderas-blue-seduction-for-men-woda-toaletowa-dla-mezczyzn-100-ml/"}, {:variant_name=>"100 ml tester", :variant_price=>51.1, :url=>"www.e-glamour.pl/antonio-banderas-blue-seduction-for-men-woda-toaletowa-dla-mezczyzn-100-ml-tester/"}, {:variant_name=>"50 ml", :variant_price=>48.2, :url=>"www.e-glamour.pl/antonio-banderas-blue-seduction-for-men-woda-toaletowa-dla-mezczyzn-50-ml/"}], "Mexx Festival Splashes wody toaletowe dla mężczyzn"=>[{:variant_name=>"50 ml", :variant_price=>26.9, :url=>"www.e-glamour.pl/mexx-festival-splashes-woda-toaletowa-dla-mezczyzn-50-ml/"}, {:variant_name=>"30 ml", :variant_price=>22.5, :url=>"www.e-glamour.pl/mexx-festival-splashes-woda-toaletowa-dla-mezczyzn-30-ml/"}], "Gabriela Sabatini Miss Gabriela wody toaletowe dla kobiet"=>[{:variant_name=>"30 ml", :variant_price=>28.6, :url=>"www.e-glamour.pl/gabriela-sabatini-miss-gabriela-woda-toaletowa-dla-kobiet-30-ml/"}, {:variant_name=>"20 ml", :variant_price=>25, :url=>"www.e-glamour.pl/gabriela-sabatini-miss-gabriela-woda-toaletowa-dla-kobiet-20-ml/"}], "Zadig & Voltaire This is Her! 100 ml woda perfumowana tester dla kobiet"=>[], "David Beckham Instinct wody toaletowe dla mężczyzn"=>[{:variant_name=>"75 ml", :variant_price=>44, :url=>"www.e-glamour.pl/david-beckham-instinct-woda-toaletowa-dla-mezczyzn-75-ml/"}, {:variant_name=>"50 ml", :variant_price=>38.7, :url=>"www.e-glamour.pl/david-beckham-instinct-woda-toaletowa-dla-mezczyzn-50-ml/"}, {:variant_name=>"30 ml", :variant_price=>34.9, :url=>"www.e-glamour.pl/david-beckham-instinct-woda-toaletowa-dla-mezczyzn-30-ml/"}], "GUESS Seductive Noir 250 ml spray do ciała dla kobiet"=>[], "Jimmy Choo Jimmy Choo wody perfumowane dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>189.36, :url=>"www.e-glamour.pl/jimmy-choo-jimmy-choo-woda-perfumowana-dla-kobiet-100-ml/"}, {:variant_name=>"100 ml tester", :variant_price=>144.6, :url=>"www.e-glamour.pl/jimmy-choo-jimmy-choo-woda-perfumowana-dla-kobiet-100-ml-tester/"}, {:variant_name=>"40 ml", :variant_price=>101.57, :url=>"www.e-glamour.pl/jimmy-choo-jimmy-choo-woda-perfumowana-dla-kobiet-40-ml/"}, {:variant_name=>"4,5 ml", :variant_price=>30.5, :url=>"www.e-glamour.pl/jimmy-choo-jimmy-choo-woda-perfumowana-dla-kobiet-4-5-ml/"}], "Calvin Klein Escape 100 ml woda perfumowana dla kobiet"=>[], "Calvin Klein Obsession wody perfumowane dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>101.5, :url=>"www.e-glamour.pl/calvin-klein-obsession-woda-perfumowana-dla-kobiet-100-ml/"}, {:variant_name=>"30 ml", :variant_price=>71.6, :url=>"www.e-glamour.pl/calvin-klein-obsession-woda-perfumowana-dla-kobiet-30-ml/"}, {:variant_name=>"15 ml", :variant_price=>45.6, :url=>"www.e-glamour.pl/calvin-klein-obsession-woda-perfumowana-dla-kobiet-15-ml/"}], "Paco Rabanne Paco 100 ml woda toaletowa unisex"=>[], "Versace Blue Jeans Man wody toaletowe dla mężczyzn"=>[{:variant_name=>"75 ml", :variant_price=>68, :url=>"www.e-glamour.pl/versace-blue-jeans-man-woda-toaletowa-dla-mezczyzn-75-ml/"}, {:variant_name=>"75 ml tester", :variant_price=>67.7, :url=>"www.e-glamour.pl/versace-blue-jeans-man-woda-toaletowa-dla-mezczyzn-75-ml-tester/"}], "Moschino Funny! wody toaletowe dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>119.9, :url=>"www.e-glamour.pl/moschino-funny-woda-toaletowa-dla-kobiet-100-ml/"}, {:variant_name=>"4 ml", :variant_price=>25.1, :url=>"www.e-glamour.pl/moschino-funny-woda-toaletowa-dla-kobiet-4-ml/"}], "GUESS Seductive Homme wody toaletowe dla mężczyzn"=>[{:variant_name=>"100 ml", :variant_price=>68.31, :url=>"www.e-glamour.pl/guess-seductive-homme-woda-toaletowa-dla-mezczyzn-100-ml/"}, {:variant_name=>"50 ml", :variant_price=>81.2, :url=>"www.e-glamour.pl/guess-seductive-homme-woda-toaletowa-dla-mezczyzn-50-ml/"}, {:variant_name=>"Zestaw", :variant_price=>107.2, :url=>"www.e-glamour.pl/guess-seductive-homme-zestaw-dla-mezczyzn-edt-100-ml-dezodorant-226-ml/"}], "Bentley Bentley For Men Absolute 100 ml woda perfumowana dla mężczyzn"=>[], "Mexx Black wody toaletowe dla kobiet"=>[{:variant_name=>"30 ml", :variant_price=>39.7, :url=>"www.e-glamour.pl/mexx-black-woda-toaletowa-dla-kobiet-30-ml/"}, {:variant_name=>"15 ml", :variant_price=>34.8, :url=>"www.e-glamour.pl/mexx-black-woda-toaletowa-dla-kobiet-15-ml/"}], "Dolce&Gabbana Light Blue wody toaletowe dla kobiet"=>[{:variant_name=>"100 ml", :variant_price=>249.77, :url=>"www.e-glamour.pl/dolce-gabbana-light-blue-woda-toaletowa-dla-kobiet-100-ml/"}, {:variant_name=>"100 ml tester", :variant_price=>192.16, :url=>"www.e-glamour.pl/dolce-gabbana-light-blue-woda-toaletowa-dla-kobiet-100-ml-tester/"}, {:variant_name=>"25 ml", :variant_price=>136.34, :url=>"www.e-glamour.pl/dolce-gabbana-light-blue-woda-toaletowa-dla-kobiet-25-ml/"}, {:variant_name=>"Zestaw", :variant_price=>275.6, :url=>"www.e-glamour.pl/dolce-gabbana-light-blue-zestaw-dla-kobiet-edt-100-ml-mleczko-do-ciala-75-ml/"}], "Jaguar Classic Chromite wody toaletowe dla mężczyzn"=>[{:variant_name=>"100 ml tester", :variant_price=>40.7, :url=>"www.e-glamour.pl/jaguar-classic-chromite-woda-toaletowa-dla-mezczyzn-100-ml-tester/"}, {:variant_name=>"Zestaw", :variant_price=>76.8, :url=>"www.e-glamour.pl/jaguar-classic-chromite-zestaw-dla-mezczyzn-edt-100-ml-zel-pod-prysznic-200-ml/"}]}


    # render json: JSON.pretty_generate(@items_sorted)
  end


end
