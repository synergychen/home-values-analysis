require "csv"

module Zillow
  class HomeValuesService
    BASE_URL = "https://www.zillow.com"
    USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"
    COOKIE_FILE = "tmp/cookie"
    ACCEPT = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng;q=0.8"
    ACCEPT_LANGUAGE = "en-US,en;q=0.9,zh-TW;q=0.8,zh;q=0.7"

    METRICS = %w[
      link
      map_link
      listing_link
      zestimate
      one_year_change
      one_year_forecast
      median_list
      median_sale
      median_rent_list
    ]

    attr_reader :city, :zipcode, :url, :request, :body, :doc

    class << self
      def export_csv
        CSV.open("tmp/zillow-home-values.csv", "wb") do |csv|
          csv << [
            "city",
            "state",
            "borough",
            "neighborhood",
            "zipcode",
            *METRICS
          ]
          City.all.each do |city|
            city.areas.each do |area|
              zillow_home_value = area.zillow_home_value
              next unless zillow_home_value
              csv << [
                city.name,
                city.state,
                area.borough,
                area.neighborhood,
                area.zipcode,
                *METRICS.map { |metric| zillow_home_value.send(metric) }
              ]
            end
          end
        end
      end
    end

    def initialize(city, state, zipcode)
      raise unless city && zipcode
      @url = get_url(city, state, zipcode)
    end

    def perform
      Typhoeus::Config.user_agent = USER_AGENT
      @request = Typhoeus::Request.get(
        @url,
        cookiefile: COOKIE_FILE,
        headers: headers)
      @body = @request.body
      @doc = Nokogiri.parse @request.body
      @request
    end

    def success?
      @request.response_code == 200
    end

    def data
      METRICS.reduce({}) do |h, metric|
        data = clean(self.send(metric)) rescue nil
        h[metric] = data
        h
      end
    end

    def print_report
      p data
    end

    private

    def get_url(city, state, zipcode)
      "#{BASE_URL}/#{city}-#{state}-#{zipcode}/home-values/"
    end

    def headers
      {
        "Accept" => ACCEPT,
        "Accept-Language" => ACCEPT_LANGUAGE
      }
    end

    def clean(string)
      string.strip.gsub("$", "").gsub(",", "").gsub("%", "")
    end

    def zestimate
      @doc.css(".region-info-item h2").children[0].content
    end

    def one_year_change
      @doc.css(".forecast-chart-hdr li")[0].children[0].content
    end

    def one_year_forecast
      @doc.css(".forecast-chart-hdr li")[1].children[0].content
    end

    def median_list
      @doc.css(".market-overview .value-info-list .value")[2].children[0].content
    end

    def median_sale
      @doc.css(".market-overview .value-info-list .value")[3].children[0].content
    end

    def median_list_per_sq_ft
      @doc.css(".listing-to-sales .value-info-list .value")[0].children[0].content
    end

    def median_rent_list
      @doc.css(".region-info li .value")[1].children[0].content
    end
  end
end
