module OtrsConnector
  class OTRS::Ticket::State < OTRS::Ticket
    
    def self.all
      data = { 'UserID' => 1 }
      #params = 'Object=StateObject&Method=StateList&Data={"UserID":"1"}'
      params = { :object => 'StateObject', :method => 'StateList', :data => data }
      a = connect(params)
      a = Hash[*a]
      b = []
      a.each do |key,value|
        c = {}
        c[key] = value
        b << c
      end
      c = []
      b.each do |d|
        d.each do |key,value|
          tmp = {}
          tmp[:id] = key
          tmp[:name] = value
          c << new(tmp)
        end
      end
      c
    end
    
  end
end