object @exchange

attributes :_id, :content, :parent_exchange_id, :parent_entry_id, :parent_comment_id, :ordered_user_ids, :ordered_usernames

child :entries => :entry_data do
  attributes :_id, :content, :user_id, :exchange_id, :username
  child :comments => :comment_data do
    attributes :_id, :content, :exchange_id, :entry_id, :entry_user_id, :child_exchange_data, :user_username
  end
end
