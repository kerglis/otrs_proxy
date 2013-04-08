module OtrsConnector
  class OTRS::Ticket::TicketQueue < OTRS::Ticket # Namespace conflict with OTRS::Ticket::Queue
    
    def self.all
      data = { 'UserID' => 1 }
      #params = 'Object=QueueObject&Method=QueueList&Data={"UserID":"1"}'
      params = { :object => 'QueueObject', :method => 'QueueList', :data => data }
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

    def self.find_id_by_queue(queue)
      data = { 'Queue' => queue }
      params = { :object => 'QueueObject', :method => 'QueueLookup', :data => data }
      queue_id = connect(params).first

      data = { 'QueueID' => queue_id }
      params = { :object => 'QueueObject', :method => 'GetQueueGroupID', :data => data }
      connect(params).first
    end
    
  end
end