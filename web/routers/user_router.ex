defmodule UserRouter do
  use Dynamo.Router

  prepare do
    conn.fetch([:cookies, :params])
  end

  post "/" do
  	username = Binary.Dict.get(Binary.Dict.get(conn.params, "user"), "username")
  	
  	user = User.new(id: :mongodb_app.next_requestid, username: username)
  	user.save

  	conn.resp(200, JSON.encode([id: user.id, username: user.username]))
  end
end
