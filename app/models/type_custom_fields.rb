class TypeCustomFields < ActiveRecord::Base
  
  validates_presence_of :descrizione
  validates_presence_of :riferimento
  
   def self.findAll
    TypeCustomFields.find(:all)
    end

end
