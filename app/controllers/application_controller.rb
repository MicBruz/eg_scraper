class ApplicationController < ActionController::Base
  
  private
  
  def call_elnino_api
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
    @total_count = { total_count: response['total_count'] }
    @current_fragrances_number = response['filter'][0]['items']
    @items_data = { items: response['items'] }
  end
  
end
