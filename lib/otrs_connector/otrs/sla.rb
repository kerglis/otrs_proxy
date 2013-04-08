module OtrsConnector
  class OTRS::Sla < OTRS

    def self.list(attributes)
      tmp = {}
      attributes.each do |key,value|
        tmp[key.to_s.camelize.to_sym] = value
      end
      attributes = tmp
      data = attributes
      #params = "$SLAObject->SLAList"
      params = { :object => 'SLAObject', :method => 'SLAList', :data => data }
      Hash[*connect(params)]
    end
      
  end
end