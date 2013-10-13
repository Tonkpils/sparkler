defmodule UserRouter do
  use Dynamo.Router

  prepare do
    conn.fetch([:cookies, :params, :session])
    unless conn.params[:user] do
      halt! conn.status(400)
    end
  end

  post "/" do
    username = conn.params |> Binary.Dict.get("user") |> Binary.Dict.get("username")
    
    if User.find({:username, username}) do
      {:ok, json_response} = JSON.encode([error: "The username has already been taken!"])
      conn.resp(400, json_response)
    else
      user = User.new(id: :mongodb_app.next_requestid, username: username)
      user = user.save

      {:ok, json_response} = JSON.encode([id: user.id, username: user.username])

      conn = put_cookie(conn, :username, user.username)

      conn.resp(200, json_response)
    end
  end
end
