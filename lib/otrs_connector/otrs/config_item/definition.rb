module OtrsConnector
  class OTRS::ConfigItem::Definition < OTRS::ConfigItem

    def initialize(attributes = {})
      attributes.each do |name, value|
        self.class.set_accessor(name)
        send("#{name.to_sym}=", value)
      end
    end

    def self.find(id)
      data = { 'DefinitionID' => id }
      params = { :object => 'ConfigItemObject', :method => 'DefinitionGet', :data => data }
      a = connect(params).first
      new(a)
    end

    def self.find_by_class_id(id)
      data = { 'ClassID' => id }
      params = { :object => 'ConfigItemObject', :method => 'DefinitionGet', :data => data }
      a = connect(params).first
      new(a)
    end
  end
end