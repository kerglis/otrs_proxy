module OtrsConnector
  class OTRS::Change::State < OTRS::Change
    @@class = 'ITSM::ChangeManagement::Change::State'
    
    def self.all
      #params = "Object=StateMachineObject&Method=StateList&Data={\"Class\":\"#{@@class}\",\"UserID\":\"1\"}"
      data = { 'Class' => @@class, 'UserID' => 1 }
      params = { :object => 'StateMachineObject', :method => 'StateList', :data => data }
      a = connect(params).flatten
      b = []
      a.each do |c|
        tmp = {}
        c.each do |key,value|
          case key
          when "Key" then tmp[:id] = value
          when "Value" then tmp[:name] = value
          end
        end
        c = tmp
        b << new(c)
      end
      b
    end
  end
end