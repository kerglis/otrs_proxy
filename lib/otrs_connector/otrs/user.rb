module OtrsConnector
  class OTRS::User < OTRS
    
    def self.find(id)
      data = { 'UserID' => id }
      params = { :object => 'UserObject', :method => 'GetUserData', :data => data }
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
      data = attributes.merge({'Valid' => 'valid'})
      params = { :object => 'UserObject', :method => 'UserSearch', :data => data }
      a = connect(params)
      a = Hash[*a]
      return a.keys if only_ids
      results = []
      a.each do |key, value|
       results << find(key)
      end
      results
    end
      
  end
end