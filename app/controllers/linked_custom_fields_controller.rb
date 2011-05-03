class LinkedCustomFieldsController < ApplicationController
before_filter :get_custom_new , :find_project, :except => [:filtra_padre_per_categoria,:update_form_issue1,:update_form_issue2]
   
    def get_custom_new
  @custom = LinkedCustomFields.new
end
 
  def find_project
    @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
  end

  def edit
         @edit_custom = LinkedCustomFields.find_by_id(params[:id])
         @tipologia = TypeCustomFields.find_by_id(@edit_custom.tipologia)
         @son_of = LinkedCustomFields.find_by_id(@edit_custom.figlia_di)
     end

      def new
        @custom = LinkedCustomFields.new
      end
  
    def create
     @custom = LinkedCustomFields.new(params[:custom])
      if @custom.save
        flash[:notice] = l(:notice_successful_create)
       redirect_to :controller => 'linked_custom_fields', :action => 'gestione',  :project_id =>@project
       else
      render :action => 'new'
      end   
    end


  def update
    @custom = LinkedCustomFields.find_by_id(params[:id])
    if request.post? and @custom.update_attributes(params[:custom])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => "gestione", :project_id =>@project
    else
      render :action => "edit", :id => params[:id]
    end
  end


   def destroy
   @custom = LinkedCustomFields.find_by_id(params[:id])
    if @custom.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    redirect_to :controller => 'linked_custom_fields', :action => 'gestione', :project_id =>@project
    end

 def filtra_padre_per_categoria
   @filtered_padre = LinkedCustomFields.find_by_sql("select linked_custom_fields.* 
                                                         from linked_custom_fields inner join type_custom_fields on linked_custom_fields.tipologia = type_custom_fields.id
                                                         where (type_custom_fields.id = (select type_custom_fields.figlia_di from type_custom_fields where type_custom_fields.id ="+params[:tipologia]+"))")
    render :layout => false
 end

 def update_form_issue1
   @filtered_custom =LinkedCustomFields.find(:all, :conditions => {:figlia_di => params[:linked_custom_id1]})
     render :layout => false
 end
 
 def update_form_issue2
   @father_filtered_custom =LinkedCustomFields.find(:all, :conditions => {:figlia_di => params[:linked_custom_id2]})
     render :layout => false
 end


  def gestione
     respond_to do |format|
        format.html { render :template => 'linked_custom_fields/elenco_valori', :layout => !request.xhr? }
   end
 end
  end
