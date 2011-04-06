class LinkedCustomFields < ActiveRecord::Base
  
    validates_presence_of :tipologia
    validates_presence_of :valore
  
  def self.findAll
    LinkedCustomFields.find(:all)
    end

end