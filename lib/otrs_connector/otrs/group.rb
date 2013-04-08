module OtrsConnector
  class OTRS::Group < OTRS

    def self.find(id)
      data = { 'ID' => id }
      params = { :object => 'UserObject', :method => 'GroupGet', :data => data }
      a = Hash[*connect(params)]
        if a.empty? == false
          self.new(a.symbolize_keys)
        else
          raise "ERROR::NoSuchID #{id}"
        end
    end

    def self.where(attributes, only_ids = false)
      tmp = {}
      attributes.each do |key,value|
        tmp[key.to_s.camelize.to_sym] = value
      end
      attributes = tmp
      data = attributes
      params = { :object => 'GroupObject', :method => 'GroupMemberList', :data => data }
      a = connect(params)
      a = Hash[*a]
      return a.keys if only_ids
      results = []
      a.each do |key, value|
       results << find(key)
      end
      results
    end

    def self.find_by_user_id_and_action(user_id, action)
      data = { 'UserID' => user_id, 'Type' => action, 'Result' => 'HASH' }
      params = { :object => 'GroupObject', :method => 'GroupMemberList', :data => data }

      Hash[*connect(params)]
    end
      
  end
end