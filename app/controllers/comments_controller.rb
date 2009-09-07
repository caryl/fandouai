class CommentsController < ApplicationController
  def create
    @commentable = Content.find(params[:article_id] || params[:page_id])
    
    @comment = Comment.new(params[:comment])
    @comment.commentable = @commentable
    @comment.set_count
    @comment.visited_ip = request.remote_ip
    @comment.user = current_user if logged_in?

    respond_to do |format|
      if Conf.captcha_on_comment ? @comment.save_with_captcha : @comment.save
        format.html { flash[:notice] = '你的评论已发表.'; redirect_to(@commentable) }
        format.js 
#        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:error] = "发生了以下错误：" << @comment.errors.full_messages.join(", ")
        format.html { redirect_to :back }
        format.js { render :update do |page| page.call :alert, flash[:error] end; flash.clear}
#        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @type = params[:type]
    if cookies[:comment_votes] && cookies[:comment_votes].split(",").include?(params[:id])
      @info = "你已参与过该投票."
    else
      if @type == 'for'
        Comment.increment_counter(:vote_for, @comment.id)
      else
        Comment.increment_counter(:vote_against, @comment.id)
      end
      if cookies[:comment_votes].nil?
        cookies[:comment_votes] = "#{@comment.id}"
      else
        cookies[:comment_votes] += ",#{@comment.id}"
      end
    end
    @comment.reload
    respond_to do |format|
      format.js
    end
  end
end
