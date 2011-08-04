require_dependency 'queries_helper'

module LinkedFieldsQueryHelperPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    base.class_eval do  
      alias_method :default_column_content, :column_content
      alias_method :column_content, :linked_column_content
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
   
    def linked_column_content(column, issue)
     
      if column.name == :linked_custom_id1
        return format_linked_field(issue.linked_custom_id1)
     end
    
      if column.name == :linked_custom_id2
        return format_linked_field(issue.linked_custom_id2)
      end
     
      if column.name == :linked_custom_id3
        return format_linked_field(issue.linked_custom_id3)
        
      else
         default_column_content(column, issue)
      end
    end
    
    
    
    def format_linked_field(link_id)
      return '' if link_id == nil
       @value = LinkedCustomFields.find_by_id(link_id)

      return @value.valore

    end
  end
end

QueriesHelper.send(:include, LinkedFieldsQueryHelperPatch)
