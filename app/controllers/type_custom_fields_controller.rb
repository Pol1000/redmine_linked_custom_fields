class TypeCustomFieldsController < ApplicationController
 
  
  before_filter :get_type_new , :find_project
   
    
  def find_project
    @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
  end
  
    def get_type_new
  @type = TypeCustomFields.new
    end
  
  
     def edit
         @type = TypeCustomFields.find_by_id(params[:id])
         @father = TypeCustomFields.find_by_id(@type.figlia_di)
     end
     
     
      def new
        @type = TypeCustomFields.new
      end
  
    def create
     @type = TypeCustomFields.new(params[:type])
      if @type.save
        flash[:notice] = l(:notice_successful_create)
       redirect_to :controller => 'type_custom_fields', :action => 'gestione', :project_id => @project
       else
      render :action => 'new'
      end   
    end


  def update
    @type = TypeCustomFields.find_by_id(params[:id])
    if request.post? and @type.update_attributes(params[:type])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => "gestione", :project_id => @project
    else
      render :action => "edit", :id => params[:id]
    end
  end


  def gestione
    @project = Project.find(params[:id] || params[:project_id])
    if User.current.allowed_to?(:edit_custom_type,@project)
     respond_to do |format|
        format.html { render :template => 'type_custom_fields/elenco_tipologie', :layout => !request.xhr? }
   end
 else
     respond_to do |format|
        format.html { render :template => 'type_custom_fields/not_allowed', :layout => !request.xhr? }
    end
   end
  end
 
   def destroy
   @customer = TypeCustomFields.find_by_id(params[:id])
    if @customer.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    redirect_to :controller => 'type_custom_fields', :action => 'gestione',  :project_id => @project
    end
end