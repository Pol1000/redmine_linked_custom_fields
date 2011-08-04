require_dependency "query"

module LinkedFieldsQueryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)
    
    # Same as typing in the class 
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      base.add_available_column(QueryColumn.new(:linked_custom_id1, :sortable => "#{Issue.table_name}.linked_custom_id1", :groupable => true))
      base.add_available_column(QueryColumn.new(:linked_custom_id2, :sortable => "#{Issue.table_name}.linked_custom_id2", :groupable => true))
      base.add_available_column(QueryColumn.new(:linked_custom_id3, :sortable => "#{Issue.table_name}.linked_custom_id3", :groupable => true))

      
      alias_method :available_filters_before_linked_custom, :available_filters
      alias_method :available_filters, :linked_custom_available_filters

      alias_method :sql_for_field_before_linked_custom, :sql_for_field
      alias_method :sql_for_field, :linked_custom_sql_for_field
    end

  end
  
  module ClassMethods
    unless Query.respond_to?(:available_columns=)
      # Setter for +available_columns+ that isn't provided by the core.
      def available_columns=(v)
        self.available_columns = (v)
      end
    end
    
    unless Query.respond_to?(:add_available_column)
      # Method to add a column to the +available_columns+ that isn't provided by the core.
      def add_available_column(column)
        self.available_columns << (column)
      end
    end
  end
  
  module InstanceMethods
    
    # Wrapper around the +available_filters+ to add a new Question filter
    def linked_custom_available_filters
      @available_filters = available_filters_before_linked_custom
      
      values = []
      values2 = []
      values3 = []
      
      
      values += LinkedCustomFields.find_by_sql("select linked_custom_fields.* from linked_custom_fields inner join type_custom_fields on linked_custom_fields.tipologia = type_custom_fields.id where (type_custom_fields.figlia_di IS NULL) AND (type_custom_fields.riferimento ='issue')").collect{ |t| [t.valore, t.id]}
      
      
      values2 += LinkedCustomFields.find_by_sql("select linked_custom_fields.* from linked_custom_fields inner join type_custom_fields on linked_custom_fields.tipologia = type_custom_fields.id where 
                                                (type_custom_fields.figlia_di IS NOT NULL) AND (type_custom_fields.riferimento ='issue')
                                                  AND linked_custom_fields.figlia_di IN (select linked_custom_fields.id from linked_custom_fields where linked_custom_fields.figlia_di IS NULL)").collect{ |t| [t.valore, t.id]}

       values3 += LinkedCustomFields.find_by_sql("select linked_custom_fields.* from linked_custom_fields inner join type_custom_fields on linked_custom_fields.tipologia = type_custom_fields.id where 
                                                (type_custom_fields.figlia_di IS NOT NULL) AND (type_custom_fields.riferimento ='issue')
                                                  AND linked_custom_fields.figlia_di IN (select linked_custom_fields.id from linked_custom_fields where linked_custom_fields.figlia_di IS NOT NULL)").collect{ |t| [t.valore, t.id]}

      linked_filters = {
        "linked_custom_fields_id" => { :type => :list, :order => 14, :values => values },
        "linked_custom_fields_id2" => { :type => :list, :order => 14, :values => values2 },
        "linked_custom_fields_id3" => { :type => :list, :order => 14, :values => values3 }
      }
      
      return @available_filters.merge(linked_filters)
    end
    

    
    
    # Wrapper for +sql_for_field+ so Questions can use a different table than Issues
    def linked_custom_sql_for_field(field,operator,v, db_table, db_field, is_custom_filter)
      if field == "linked_custom_fields_id" ||  field == "linked_custom_fields_id2" ||  field == "linked_custom_fields_id3"
       
        if field == "linked_custom_fields_id"
          v = values_for(field).clone
        end
        
        if field == "linked_custom_fields_id2"
          v2 = values_for(field).clone
        end
        
        if field == "linked_custom_fields_id3"
          v3 = values_for(field).clone
        end
        db_field = nil
        
        db_field2 = nil
        
        db_field3 = nil
         
        db_table = "issues"
        
        if field == "linked_custom_fields_id"
          db_field = 'linked_custom_id1'
        end
        if field == "linked_custom_fields_id2"
            db_field2 = "linked_custom_id2"
        end
         if field == "linked_custom_fields_id3"
            db_field3 = "linked_custom_id3"
        end
        
        # "me" value subsitution
       # v.push(User.current.logged? ? User.current.id.to_s : "0") if v.delete("me")
        
        case operator_for field
        when "="
          
          use_and = false
          sql=""
          if db_field!= nil
          sql += "#{db_table}.#{db_field} IN (" + v.collect{|val| "'#{connection.quote_string(val)}'"}.join(",") + ")"
          use_and = true
         end
         
         if db_field2!= nil
           if use_and
             sql+=" and "
           end
           sql += "#{db_table}.#{db_field2} IN (" + v2.collect{|val| "'#{connection.quote_string(val)}'"}.join(",") + ")"
           use_and = true
          end
        
         if db_field3!= nil
           if use_and
             sql+=" and "
           end
            sql += "#{db_table}.#{db_field3} IN (" + v3.collect{|val| "'#{connection.quote_string(val)}'"}.join(",") + ")"
          end
          
        when "!"
          
          use_and = false
          sql=""
          if db_field!= nil
          sql +="(#{db_table}.#{db_field} IS NULL OR #{db_table}.#{db_field} NOT IN (" + v.collect{|val| "'#{connection.quote_string(val)}'"}.join(",") + "))"
          use_and = true
         end
         
         if db_field2!= nil
           if use_and
             sql+=" and "
           end
           sql += "(#{db_table}.#{db_field2} IS NULL OR #{db_table}.#{db_field2} NOT IN (" + v.collect{|val| "'#{connection.quote_string(val)}'"}.join(",") + "))"
           use_and = true
          end
        
         if db_field3!= nil
           if use_and
             sql+=" and "
           end
            sql += "(#{db_table}.#{db_field3} IS NULL OR #{db_table}.#{db_field3} NOT IN (" + v.collect{|val| "'#{connection.quote_string(val)}'"}.join(",") + "))"
          end
        end

        return sql
        
      else
        return sql_for_field_before_linked_custom(field,operator, v, db_table, db_field, is_custom_filter)
      end
      
    end
    
  end  
end

Query.send(:include, LinkedFieldsQueryPatch)
