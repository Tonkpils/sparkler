defmodule UserRouter do
  use Dynamo.Router

  prepare do
    conn = conn.fetch([:cookies, :params, :session])
    conn.assign :layout, "application"
  end


  post "/" do
    unless conn.params[:user] do
      halt! conn.status(400)
    end
    username = conn.params |> Binary.Dict.get("user") |> Binary.Dict.get("username")
    
    if User.find({:username, username}) do
      {:ok, json_response} = JSON.encode([error: "The username has already been taken!"])
      conn.resp(400, json_response)
    else
      user = User.new(id: :mongodb_app.next_requestid, username: username)
      user = user.save

      conn = put_cookie(conn, :username, user.username)

      redirect(conn, to: "/users/#{user.username}")
    end
  end

  @prepare :authorize_user
  get "/:username" do
    if get_cookie(conn, :username) != conn.params[:username] do
      IO.puts "YOU DONT MATCH"
    end

    user_streamed = User.find_all({}) 
                      |> Stream.map(fn(user) -> [id: user.id, username: user.username] end)

    user_list = Enum.to_list(user_streamed)

    conn = conn.assign(:users_json, user_list)
    render conn, "chat.html"

  end

  defp authorize_user(conn) do
    unless get_cookie(conn, :username) do
      halt! conn.status(401)
    end
    conn
  end

end
