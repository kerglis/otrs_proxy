module OtrsConnector
  class OTRS::Ticket < OTRS
    # Validations aren't working
    validates_presence_of :title
    validates_presence_of :body
    validates_presence_of :email

    def self.free_text_get(type, user_id, ticket_id = nil)
      data = { 'Type' => type, 'UserID' => user_id }
      data.merge!({'TicketID' => ticket_id}) if ticket_id
      params = { :object => 'TicketObject', :method => 'TicketFreeTextGet', :data => data }
      connect(params).first
    end

    def self.free_text_set(user_id, ticket_id, key, value, counter)
      data = { 
        "Counter" => counter,
        "Key" => key,
        "Value" => value,
        "UserID" => user_id,
        "TicketID" => ticket_id
      }

      params = { :object => 'TicketObject', :method => 'TicketFreeTextSet', :data => data }
      connect(params).first
    end

    def self.pending_time_set(user_id, ticket_id, time)
      data = { 
        "String" => time.strftime('%Y-%m-%d %H:%M:00'),
        "UserID" => user_id,
        "TicketID" => ticket_id
      }

      params = { :object => 'TicketObject', :method => 'TicketPendingTimeSet', :data => data }
      connect(params).first
    end
    
    def self.ticket_number_lookup(ticket_id)
      data = { 'TicketID' => ticket_id, 'UserID' => 1 }
      #params = "Object=TicketObject&Method=TicketNumberLookup&Data={\"TicketID\":\"#{ticket_id}\",\"UserID\":\"1\"}"
      params = { :object => 'TicketObject', :method => 'TicketNumberLookup', :data => data }
      connect(params)
    end

    def self.simple_create!(data)
      params = { :object => 'TicketObject', :method => 'TicketCreate', :data => data }
      a = connect(params)
      ticket_id = a.first
      self.find(ticket_id)
    end
    
    def create(attributes)
      attributes[:otrs_type] ||= 'Incident'
      attributes[:state] ||= 'new'
      attributes[:queue] ||= 'Service Desk'
      attributes[:lock] ||= 'unlock'
      attributes[:priority] ||= '3 normal'
      attributes[:user_id] ||= '1'
      attributes[:owner_id] ||= attributes[:user_id]
      tmp = {}
      attributes.each do |key,value|
        if key == :otrs_type
          tmp[:Type] = value
        end
        if key == :user_id
          tmp[:UserID] = value
        end
        if key == :owner_id
          tmp[:OwnerID] = value
        end
        if key == :customer_id
          tmp[:CustomerID] = value
        end
        if key != :user_id or key != :owner_id or key != :customer_id
          tmp[key.to_s.camelize.to_sym] = value
        end

      end
      attributes = tmp
      data = attributes
      params = { :object => 'TicketObject', :method => 'TicketCreate', :data => data }
      a = connect(params)
      ticket_id = a.first
      article = OTRS::Ticket::Article.new(
        :ticket_id => ticket_id, 
        :body => attributes[:Body], 
        :email => attributes[:Email], 
        :title => attributes[:Title])
      if article.save
        ticket = self.class.find(ticket_id)
        attributes = ticket.attributes
        attributes.each do |key,value|
          instance_variable_set "@#{key.to_s}", value
        end
        ticket
      else
        ticket.destroy
        raise 'Could not create ticket'
      end
    end
    
    def destroy
      id = @ticket_id
      if self.class.find(id)
        data = { 'TicketID' => id, 'UserID' => 1 }
        params = { :object => 'TicketObject', :method => 'TicketDelete', :data => data }
        connect(params)
        "Ticket ID: #{id} deleted"
      else
        raise 'Error:NoSuchID'
      end
    end
    
    def self.find(id)
      data = { 'TicketID' => id, 'UserID' => 1 }
      #params = "Object=TicketObject&Method=TicketGet&Data={\"TicketID\":\"#{id}\",\"UserID\":\"1\"}"
      params = { :object => 'TicketObject', :method => 'TicketGet', :data => data }
      a = Hash[*connect(params)]
      if a.empty? == false
        self.new(a.symbolize_keys)
      else
        raise "ERROR::NoSuchID #{id}"
      end
    end
    
    
    def self.where(attributes)
      data = attributes
      params = { :object => 'TicketObject', :method => 'TicketSearch', :data => data }
      a = connect(params)
      b = Hash[*a]          # Converts array to hash where key = TicketID and value = TicketNumber, which is what gets returned by OTRS
      c = []
      b.each do |key,value| # Get just the ID values so we can perform a find on them
        c << key
      end
      results = []
      c.each do |t|
        results << find(t)  #Add find results to array
      end
      results   # Return array of hashes.  Each hash is one ticket record
    end
    
    def where(attributes)
      self.class.where(attributes)
    end

    def self.delete_by_id(id)
      if find(id)
        data = { 'TicketID' => id, 'UserID' => 1 }
        params = { :object => 'TicketObject', :method => 'TicketDelete', :data => data }
        connect(params)
        "Ticket ID: #{id} deleted"
      else
        raise 'Error:NoSuchID'
      end
    end
  end
end