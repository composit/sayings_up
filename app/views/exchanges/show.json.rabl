object @exchange

attributes :_id, :content, :parent_exchange_id, :parent_entry_id, :parent_comment_id, :ordered_user_ids, :ordered_usernames

child entries: :entry_data do
  extends 'entries/show'
end
