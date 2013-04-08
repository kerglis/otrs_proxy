module OtrsConnector
  class OTRS::Link < OTRS
    
    def self.create(attributes)
      attributes["State"] ||= 'Valid'
      params = { :object => 'LinkObject', :method => 'LinkAdd', :data => attributes }
      a = connect(params)
      if a.first == "1"
        return self
      else
        nil
      end
    end

    def self.where_with_data(attributes)
      attributes["State"] ||= 'Valid'
      attributes["Object"] ||= "ITSMConfigItem"
      params = { :object => 'LinkObject', :method => 'LinkListWithData', :data => attributes }
      a = connect(params)
      result = []

      (a.first["Ticket"]["RelevantTo"]["Source"].values rescue []).each do |ticket|
        result << OTRS::Ticket.new(ticket.symbolize_keys)
      end

      (a.first["Ticket"]["DependsOn"]["Target"].values rescue []).each do |ticket|
        result << OTRS::Ticket.new(ticket.symbolize_keys)
      end

      result
    end
    
    def self.where(attributes)
      # Returns list of link objects as Source => Target
      # Haven't decided if I want this to return the link object or what is being linked to
      attributes[:state] ||= 'Valid'
      tmp = {}
      attributes.each do |key,value|
        tmp[key.to_s.camelize.to_sym] = value
      end
      data = tmp
      params = { :object => 'LinkObject', :method => 'LinkKeyList', :data => data }
      a = connect(params)
      a = Hash[*a]
      b = []
      a.each do |key,value|
        c = {}
        c[:key2] = "#{key}"
        c[:object2] = tmp[:Object2]
        c[:object1] = tmp[:Object1]
        c[:key1] = tmp[:Key1]
        b << self.new(c)
      end
      b
    end
    
    def where(attributes)
      self.class.where(attributes)
    end

    def destroy
      @type ||= 'Normal'
      data = { 'Object1' => @object1, :key1 => @key1, :object2 => @object2, key2 => @key2, :type => @type }
      #params = "Object=LinkObject&Method=LinkDelete&Data={\"Object1\":\"#{@object1}\",\"Key1\":\"#{@key1}\",\"Object2\":\"#{@object2}\",\"Key2\":\"#{@key2}\",\"Type\":\"#{@type}\"}"
      params = { :object => 'LinkObject', :method => 'LinkDelete', :data => data }
      a = connect(params)
    end

  end
end