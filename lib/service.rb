class Service
  class << self
#    extend ActiveSupport::Memoizable

    def client
      @client ||= Savon::Client.new "http://www.webservicex.net/country.asmx?WSDL"
    end

#    def countries
#      doc = Nokogiri::XML(process(:get_countries))
#      doc.xpath('//Name/text()').collect &:to_s
#    end
#
#    def currencies
#      process :get_currency_code
#    end
    
    # [{:country => '', :currency_code => '', :currency => ''}]
    def data
      Rails.cache.fetch(:service_data) do
        doc = Nokogiri::XML(process(:get_currency_code))
        out = []
        doc.xpath('//Table').each do |d|
          currency_code = d.at_xpath('./CurrencyCode/text()').to_s
          out << {
            :country  => d.at_xpath('./Name/text()').to_s,     :country_code  => d.at_xpath('./CountryCode/text()').to_s,
            :currency => d.at_xpath('./Currency/text()').to_s, :currency_code => currency_code
          } unless currency_code.blank? # some of currencies has blank code..skip it
        end

        # add number of coutries that offer a currency
        out.each do |o|
          o[:offer_count] = out.find_all{|_o| _o[:currency_code] == o[:currency_code] }.size
          # and save it
          Country.create!(:code => o[:country_code], :name => o[:country]) unless Country.exists?(:code => o[:country_code])
        end
        
        out
      end
    end
#    memoize :data

#    private

    def process(method)
      client.request(method.to_sym) do |soap|
        soap.input = [
          method.to_s.camelize,
          { "xmlns" => "http://www.webserviceX.NET/" } # http://stackoverflow.com/questions/3453275/consume-soap-service-with-ruby-and-savon
        ]
      end.to_hash["#{method}_response".to_sym]["#{method}_result".to_sym]
    end
  end
end

#Savon.configure do |config|
#  config.logger = Logger.new(STDOUT)
#end