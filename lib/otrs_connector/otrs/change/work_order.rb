module OtrsConnector
  class OTRS::Change::WorkOrder < OTRS::Change
    
    def create(attributes)
      tmp = {}
      attributes.each do |key,value|
        tmp[key.to_s.camelize.to_sym] = value
      end
      attributes = tmp
      attributes[:UserID] = '1'
      attributes[:ChangeID] = attributes[:ChangeId]
      attributes.delete(:ChangeId)
      data = attributes
      params = { :object => 'WorkOrderObject', :method => 'WorkOrderAdd', :data => data }
      a = connect(params)
      id = a.first
      if id.nil?
        nil
      else
        b = self.class.find(id)
        attributes = b.attributes
        attributes.each do |key,value|
          instance_variable_set "@#{key.to_s}", value
        end
        b
      end
    end
    
    def update_attributes(attributes)
      tmp = {}
      attributes.each do |key,value|
        tmp[key.to_s.camelize] = value      #Copies ruby style keys to camel case for OTRS
      end
      tmp['WorkOrderID'] = @work_order_id
      data = tmp
      params = { :object => 'WorkOrderObject', :method => 'WorkOrderUpdate', :data => data }
      a = connect(params)
      if a.first.nil?
        nil
      else
        return self
      end
    end
    
    def self.find(id)
      data = { 'WorkOrderID' => id, 'UserID' => 1 }
      params = { :object => 'WorkOrderObject', :method => 'WorkOrderGet', :data => data }
      a = connect(params)
      a = Hash[*a]
      self.new(a.symbolize_keys)
    end
    
    def destroy
      id = @change_id
      if self.class.find(id)
        data = { 'ChangeID' => id, 'UserID' => 1 }
        params = { :object => 'WorkOrderObject', :method => 'WorkOrderDelete', :data => data }
        connect(params)
        "WorkOrderID #{id} deleted"
      else
        raise "NoSuchWorkOrderID #{id}"
      end
    end
    
  end
end