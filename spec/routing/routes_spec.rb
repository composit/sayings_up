require 'spec_helper'

describe 'Routes' do
  specify { { get: 'exchanges' }.should route_to( controller: 'exchanges', action: 'index' ) }
  specify { { get: 'exchanges/1' }.should route_to( controller: 'exchanges', action: 'show', id: '1' ) }
  specify { { post: 'exchanges' }.should route_to( controller: 'exchanges', action: 'create' ) }
  specify { { put: 'exchanges/1' }.should_not be_routable }
  specify { { delete: 'exchanges/1' }.should_not be_routable }

  #specify { { get: 'exchanges/1/entries' }.should route_to( controller: 'entries', action: 'index', exchange_id: '1' ) }
  specify { { get: 'exchanges/1/entries' }.should_not be_routable }
  specify { { get: 'exchanges/1/entries/2' }.should route_to( controller: 'entries', action: 'show', exchange_id: '1', id: '2' ) }
  specify { { post: 'exchanges/1/entries' }.should route_to( controller: 'entries', action: 'create', exchange_id: '1' ) }
  specify { { put: 'exchanges/1/entries/2' }.should_not be_routable }
  specify { { delete: 'exchanges/1/entries/2' }.should_not be_routable }

  #specify { { get: 'exchanges/1/entries/2/comments' }.should route_to( controller: 'comments', action: 'index', exchange_id: '1', entry_id: '2' ) }
  specify { { get: 'exchanges/1/entries/2/comments' }.should_not be_routable }
  specify { { get: 'exchanges/1/entries/2/comments/3' }.should route_to( controller: 'comments', action: 'show', exchange_id: '1', entry_id: '2', id: '3' ) }
  specify { { post: 'exchanges/1/entries/2/comments' }.should route_to( controller: 'comments', action: 'create', exchange_id: '1', entry_id: '2' ) }
  specify { { put: 'exchanges/1/entries/2/comments/3' }.should_not be_routable }
  specify { { delete: 'exchanges/1/entries/2/comments/3' }.should_not be_routable }

  specify { { get: 'users' }.should_not be_routable }
  specify { { get: 'users/1' }.should route_to( controller: 'users', action: 'show', id: '1' ) }
  specify { { post: 'users' }.should route_to( controller: 'users', action: 'create' ) }
  specify { { put: 'users/1' }.should_not be_routable }
  specify { { delete: 'users/1' }.should_not be_routable }

  specify { { get: 'user_sessions' }.should_not be_routable }
  specify { { get: 'user_sessions/1' }.should_not be_routable }
  specify { { post: 'user_sessions' }.should route_to( controller: 'user_sessions', action: 'create' ) }
  specify { { put: 'user_sessions/1' }.should_not be_routable }
  specify { { delete: 'user_sessions/1' }.should route_to( controller: 'user_sessions', action: 'destroy', id: '1' ) }
end
