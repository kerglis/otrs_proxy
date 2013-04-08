module OtrsConnector
  class OTRS::Service < OTRS
    
    def self.find(id)
      #params = "Object=ServiceObject&Method=ServiceGet&Data={\"ServiceID\":\"#{id}\",\"UserID\":\"1\"}"
      data = { 'ServiceID' => id, 'UserID' => 1 }
      params = { :object => 'ServiceObject', :method => 'ServiceGet', :data => data }
      a = Hash[*connect(params)]
        if a.empty? == false
          self.new(a.symbolize_keys)
        else
          raise "ERROR::NoSuchID #{id}"
        end
    end
    
    def create(attributes)
      attributes[:valid_id] ||= 1
      attributes[:user_id] ||= 1
      attributes[:type_id] ||= 1
      attributes[:criticality_id] ||= 3
      tmp = {}
      attributes.each do |key,value|
        if key == :user_id
          tmp[:UserID] = value
        end
        if key == :valid_id
          tmp[:ValidID] = value
        end
        if key == :type_id
          tmp[:TypeID] = value
        end
        if key == :criticality_id
          tmp[:CriticalityID] = value
        end
        if key == :parent_id
          tmp[:ParentID] = value
        end
        if key != :user_id or key != :valid_id or key != :type_id or key != :crticality_id or key != :parent_id
          tmp[key.to_s.camelize.to_sym] = value
        end
      end
      attributes = tmp
      data = attributes
      #params = "Object=ServiceObject&Method=ServiceAdd&Data=#{data}"
      params = { :object => 'ServiceObject', :method => 'ServiceAdd', :data => data }
      a = connect(params)
      service_id = a.first
      unless service_id.nil?
        self.class.find(service_id)
      else
        raise "Could not create service"
      end
      service = self.class.find(service_id)
      service.attributes.each do |key,value|
        instance_variable_set "@#{key.to_s}", value
      end
      service
    end

    def self.where(attributes)
      tmp = {}
      attributes.each do |key,value|
        tmp[key.to_s.camelize.to_sym] = value
      end
      attributes = tmp
      data = attributes
      #params = "Object=ServiceObject&Method=ServiceSearch&Data=#{data}"
      params = { :object => 'ServiceObject', :method => 'ServiceSearch', :data => data }
      a = connect(params)
      results = []
      a.each do |s|
       results << find(s)
      end
      results
    end

    # services = OtrsConnector::OTRS::Service.user_list('AUTO-110929111155')
    def self.user_list(login)
      data = {:CustomerUserLogin => login,
        :Result            => 'HASH',
        :DefaultServices   => 0}
      params = { :object => 'ServiceObject', :method => 'CustomerUserServiceMemberList', :data => data }
      Hash[*connect(params)]
    end
      
  end
end