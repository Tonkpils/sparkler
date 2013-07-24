initializer :dynamo do
  mongo_url = System.get_env("MONGOHQ_URL")
  settings  = Regex.captures(%r/mongodb:\/\/(?<username>(.*)):(?<password>(.*))@(?<host>(.*)):(?<port>(\d+))\/(?<db_name>(.*))/g, mongo_url)

  # Mongoex requires the settings to be atom, char_list and integer...
  database = binary_to_atom(settings[:db_name])
  address  = to_char_list(settings[:host])
  port     = binary_to_integer(settings[:port])

  Mongoex.Server.setup(address: address, port: port, database: database,
                username: settings[:username], password: settings[:password], pool: 4)

  Mongoex.Server.start
end

config :dynamo,
  # On production, modules are compiled up-front.
  compile_on_demand: false,
  reload_modules: false

config :server,
  port: 8888,
  acceptors: 100,
  max_connections: 10000

# config :ssl,
#  port: 8889,
#  keyfile: "/var/www/key.pem",
#  certfile: "/var/www/cert.pem"
