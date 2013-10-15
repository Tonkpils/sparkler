defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn = conn.fetch([:cookies, :params, :session])
    username = get_cookie(conn, :username)

    if username do
      case User.find({:username, get_cookie(conn, :username)}) do
        nil -> nil
        current_user -> conn = conn.assign(:current_user, current_user)
      end
    end

    conn.assign :layout, "application"
  end

  # It is common to break your Dynamo in many
  # routers forwarding the requests between them
  # forward "/posts", to: PostsRouter

  forward "/users", to: UserRouter
  

  get "/" do    
    if conn.assigns[:current_user] do
      redirect!(conn, to: "/users/#{conn.assigns[:current_user].username}")
    end

    conn = conn.assign(:title, "Welcome to Sparky Chat on Dynamo!")
    conn = conn.assign(:header, "Sparky Chat!")

    user_streamed = User.find_all({}) 
                      |> Stream.map(fn(user) -> [id: user.id, username: user.username] end)

    user_list = Enum.to_list(user_streamed)

    conn = conn.assign(:users_json, user_list)
    render conn, "index.html"
  end
end
