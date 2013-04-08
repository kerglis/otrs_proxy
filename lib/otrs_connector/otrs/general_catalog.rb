module OtrsConnector
  class OTRS::GeneralCatalog < OTRS
    
    def self.find(id)
      data = { 'ItemID' => id }
      params = { :object => 'GeneralCatalogObject', :method => 'ItemGet', :data => data }
      a = connect(params)
      unless a.first.nil?
        a = a.first.except('Class') ## Class field is causing issues in Rails
      end
      self.new(a)
    end
    
  end
end