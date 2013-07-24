defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params, :session])

    conn.assign :layout, "application"
  end

  # It is common to break your Dynamo in many
  # routers forwarding the requests between them
  # forward "/posts", to: PostsRouter

  forward "/users", to: UserRouter
  
  get "/" do
    conn = conn.assign(:title, "Welcome to Sparky Chat on Dynamo!")
    conn = conn.assign(:header, "Sparky Chat!")


    user_streamed = User.find_all({}) |> Stream.map(fn(user) -> 
                                                      [id: user.id, username: user.username] 
                                                    end)
    #users_json = JSON.encode(Enum.to_list(user_streamed))
    user_list = Enum.to_list(user_streamed)

    conn = conn.assign(:users_json, user_list)
    render conn, "index.html"
  end
end
