class LinkedFieldsHooks < Redmine::Hook::ViewListener
 
 include ActionView::Helpers::PrototypeHelper
 
 def view_issues_form_details_bottom(params)
   
       @issue = params[:issue]
    if @issue.project.module_enabled?(:linked_custom_fields)
        html =""
        html += "<p>"
        html += params[:form].select :linked_custom_id1, LinkedCustomFields.find_by_sql("select linked_custom_fields.* from linked_custom_fields inner join type_custom_fields on linked_custom_fields.tipologia = type_custom_fields.id where (type_custom_fields.figlia_di IS NULL) AND (type_custom_fields.riferimento ='issue') ").collect{ |t| [t.valore, t.id]}, :include_blank => true
        html += observe_field :issue_linked_custom_id1, :url => {:controller => 'linked_custom_fields', :action => :update_form_issue1},
                                     :update => :primo_select,
                                     :with => :linked_custom_id1              
        html += "<div id='primo_select'></div>"
        html += "</p>"
        html
   end    
    end

 def protect_against_forgery?
    false
   end
end


#    if authorize_for('linked_custom_fields', 'create')