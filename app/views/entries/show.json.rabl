object @entry

attributes :_id, :content, :user_id, :exchange_id, :username

child comments: :comment_data do
  extends 'comments/show'
end
