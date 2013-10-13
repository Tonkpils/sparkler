defmodule ChatRouter do
  use Dynamo.Router

  prepare do
    conn.fetch([:cookes, :params])
  end
end

