class LinkedFieldsHooks < Redmine::Hook::ViewListener
 
 def view_issues_form_details_bottom(params)
        html = ""
        html += "<p>"
        html += params[:form].select :type_id, TypeCustomFields.find(:all, :conditions => {:riferimento => "issue"}).collect{ |t| [t.descrizione, t.id]}, :include_blank => true
        html += "</p>"
        html += "<p>"
        html += params[:form].select :linked_custom_id, LinkedCustomFields.find(:all, :conditions => {:tipologia => :type_id}).collect{ |l| [l.valore, l.id]}, :include_blank => true
        html += "</p>"
        html
       
    end
    
end