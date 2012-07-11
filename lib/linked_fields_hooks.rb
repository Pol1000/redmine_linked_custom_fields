class LinkedFieldsHooks < Redmine::Hook::ViewListener
 
 include ActionView::Helpers::PrototypeHelper
 
 def view_issues_form_details_bottom(params)
   
       @issue = params[:issue]
    if @issue.project.module_enabled?(:linked_custom_fields)                                   
        html =""
        html += "<p>"
        html += params[:form].select :linked_custom_id1, LinkedCustomFields.find_by_sql("select linked_custom_fields.* from linked_custom_fields inner join type_custom_fields on linked_custom_fields.tipologia = type_custom_fields.id where (type_custom_fields.figlia_di IS NULL) AND (type_custom_fields.riferimento ='issue') ").collect{ |t| [t.valore, t.id]},:required => true, :include_blank => true
        html += "</p>"
        
        html += "<p>"
        html += params[:form].select :linked_custom_id2,LinkedCustomFields.find_by_sql("select linked_custom_fields.* from linked_custom_fields inner join type_custom_fields on linked_custom_fields.tipologia = type_custom_fields.id where (type_custom_fields.figlia_di in (select id from type_custom_fields where (type_custom_fields.figlia_di IS NULL) AND (type_custom_fields.riferimento ='issue')) AND (type_custom_fields.riferimento ='issue') )").collect{ |t| [t.valore, t.id]} ,:include_blank => true
        html += "</p>"
        
        html += "<p>"
        html += params[:form].select :linked_custom_id3,LinkedCustomFields.find_by_sql("select linked_custom_fields.* from linked_custom_fields inner join type_custom_fields on linked_custom_fields.tipologia = type_custom_fields.id where (type_custom_fields.figlia_di in (select id from type_custom_fields where(type_custom_fields.figlia_di IS NOT NULL) AND (type_custom_fields.riferimento ='issue')) AND (type_custom_fields.riferimento ='issue')) ").collect{ |t| [t.valore, t.id]}, :include_blank => true
        html += "</p>"
        html += "<p>"
        html += observe_field :issue_linked_custom_id1, :url => {:controller => 'linked_custom_fields', :action => :update_form_issue1},
                                     :update => :issue_linked_custom_id2,
                                     :with => :linked_custom_id1
     
        html += observe_field :issue_linked_custom_id2, :url => {:controller => 'linked_custom_fields', :action => :update_form_issue2},
                                     :update => :issue_linked_custom_id3,
                                     :with => :linked_custom_id2
                                     
      
    
        html += "</p>"
        html
   end    
    end




#def check_for_linked
#   if @issue.project.module_enabled?(:linked_custom_fields)
#     if  params[:linked_custom_id1].blank?
#       render_error (":linked_custom_id1")
#     end
#   end
#end


#def view_issues_form_details_top(params)
#     @issue = params[:issue]
#     if @issue.project.module_enabled?(:linked_custom_fields)
#        
#          @applicativo =LinkedCustomFields.find_by_id(@issue.linked_custom_id2)
#    
#          @modulo =LinkedCustomFields.find_by_id(@issue.linked_custom_id3)
#     end
#end

 def view_issues_show_details_bottom(params)
   
       @issue = params[:issue]
      if @issue.project.module_enabled?(:linked_custom_fields)
        @area = LinkedCustomFields.find_by_id(@issue.linked_custom_id1)
        if (@area)
          s="<tr><td><b>Area:</b></td><td>#{@area.valore}</td></tr>"
          @applicativo =LinkedCustomFields.find_by_id(@issue.linked_custom_id2)
          if (@applicativo)
            s+="<tr><td><b>Applicativo:</b></td><td>#{@applicativo.valore}</td></tr>"
            @modulo =LinkedCustomFields.find_by_id(@issue.linked_custom_id3)
           if (@modulo)
            s+="<tr><td><b>Modulo:</b></td><td>#{@modulo.valore}</td></tr>"
           end
          end
         return s
        else
         return ""
        end
    end
end

 def protect_against_forgery?
    false
  end
  
  
  
 def helper_issues_show_detail_after_setting(context = {})
   
    detail    = context[:detail]
    label     = context[:detail].prop_key
    value     = context[:detail].value
    old_value = context[:detail].old_value

    if (label == "linked_custom_id1") ||(label == "linked_custom_id2") || (label == "linked_custom_id3")
      
       @custom = LinkedCustomFields.find_by_id(value)
       @custom_old = LinkedCustomFields.find_by_id(old_value)
      context[:detail].value = @custom.valore
      if(@custom_old!= nil)
        context[:detail].old_value = @custom_old.valore
      end
    end
    
  end
#  def view_issues_show_description_bottom(params)
#   
#       @issue = params[:issue]
#      if @issue.project.module_enabled?(:linked_custom_fields)
#        @area = LinkedCustomFields.find_by_id(@issue.linked_custom_id1)
#        if (@area)
#          s="<tr><td><b>Area:</b></td><td>#{@area.valore}</td></tr>"
#          @applicativo =LinkedCustomFields.find_by_id(@issue.linked_custom_id2)
#          if (@applicativo)
#            s+="<tr><td><b>Applicativo:</b></td><td>#{@applicativo.valore}</td></tr>"
#            @modulo =LinkedCustomFields.find_by_id(@issue.linked_custom_id3)
#           if (@modulo)
#            s+="<tr><td><b>Modulo:</b></td><td>#{@modulo.valore}</td></tr>"
#           end
#          end
#         return s
#        else
#         return ""
#     end
#   else
#     return ""
#    end
#end

  
  
  
end




#    if authorize_for('linked_custom_fields', 'create')