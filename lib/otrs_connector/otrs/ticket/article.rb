module OtrsConnector
  class OTRS::Ticket::Article < OTRS::Ticket

    def self.simple_create!(data)
      params = { :object => 'TicketObject', :method => 'ArticleCreate', :data => data }
      a = connect(params)
      a.first.nil? ? nil : a
    end
    
    def create(attributes)
      data = { 'TicketID' => attributes[:ticket_id], 'From' => attributes[:email], 'Subject' => attributes[:title], 'Body' => attributes[:body] }
      data['ArticleType'] ||= 'email-external'
      data['UserID'] ||= 1
      data['SenderType'] ||= 'agent'
      data['HistoryType'] ||= 'NewTicket'
      data['HistoryComment'] ||= ' '
      data['ContentType'] ||= 'text/plain'
      params = { :object => 'TicketObject', :method => 'ArticleCreate', :data => data }
      a = connect(params)
      if a.first.nil? then nil else a end
    end
    
    def self.find(id)
      data = { 'ArticleID' => id, 'UserID' => 1 }
      params = { :object => 'TicketObject', :method => 'ArticleGet', :data => data }
      a = connect(params)
      a = Hash[*a].symbolize_keys
      self.new(a)
    end
    
    def self.where(ticket_id)
      data = { 'TicketID' => ticket_id }
      params = { :object => 'TicketObject', :method => 'ArticleIndex', :data => data }
      a = connect(params)
      b = []
      a.each do |c|
        b << find(c)
      end
      b
    end

  end
end