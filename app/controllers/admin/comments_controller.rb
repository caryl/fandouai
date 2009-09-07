class Admin::CommentsController < ApplicationController
  layout 'admin'
  deny :exec => '!logged_in?'
  allow :user => :is_admin?
  def index
    scope = Comment
    scope = scope.with_search(params[:q]) if params[:q].present?
    @comments = scope.paginate(:include => [:commentable, :user], :page=>params[:page]||1, :order => 'comments.id desc')

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @comments }
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(admin_comments_path) }
#        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
#        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(admin_comments_url) }
#      format.xml  { head :ok }
    end
  end
end
