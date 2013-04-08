module OtrsConnector
  class OTRS < ActiveRecord::Base
    # include ActiveModel::Conversion
    # include ActiveModel::Naming
    # include ActiveModel::Validations
    
    def self.user
      $otrs_user
    end
    
    def self.password
      $otrs_pass
    end
    
    def self.host
      $otrs_host
    end
    
    def self.api_url
      $otrs_api_url
    end

    def self.configuration
      $configuration
    end
    
    def self.connect(params)
      base_url = self.api_url
      logon = URI.encode("User=#{self.user}&Password=#{self.password}")
      object = URI.encode(params[:object])
      method = URI.encode(params[:method])
      data = params[:data].to_json
      data = URI.encode(data)
      data = URI.escape(data, '=\',\\/+-&?#.;')
      uri = URI.parse("#{base_url}?#{logon}&Object=#{object}&Method=#{method}&Data=#{data}")
      
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = false
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      result = ActiveSupport::JSON::decode(response.body)

      raise "Can't parse OTRS response: [#{response.body}], params: [#{params}]" unless result

      return result["Data"] if result["Result"] == 'successful'
        
      if result['Message'].blank?
        result["Data"]
      else
        raise "Error:#{result["Result"]} #{result["Message"]}"
      end
    end
    
    def connect(params)
      self.class.connect(params)
    end

    # start model methods

    def self.set_accessor(key)
      attr_accessor key.to_sym
    end
    
    def persisted?
      false
    end
    
    def initialize(attributes = {})
      attributes.each do |name, value|
        self.class.set_accessor(name.to_s.underscore)
        send("#{name.to_s.underscore.to_sym}=", value)
      end
    end
    
    def attributes
      attributes = {}
      self.instance_variables.each do |v|
        attributes[v.to_s.gsub('@','').to_sym] = self.instance_variable_get(v)
      end
      attributes
    end

    class << self
      def table_name
        self.name.tableize
      end
    end

    def self.columns
      @columns ||= [];
    end
    
    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end

    def save(validate = true)
      self.create(self.attributes)
    end
    
    # def save
    #   self.create(self.attributes)
    # end

    # end model methods
  end
end