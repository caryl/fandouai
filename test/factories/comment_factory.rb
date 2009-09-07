Factory.define :comment do |comment|
  comment.commentable_type 'MyString'
  comment.commentable_id '1'
  comment.title 'MyString'
  comment.content ''
  comment.user_id '1'
  comment.visitor_name 'MyString'
  comment.visited_ip 'MyString'
  comment.vote_for '1'
  comment.vote_against '1'
  comment.state_id '1'
end
