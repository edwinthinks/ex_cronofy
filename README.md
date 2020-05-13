# ExCronofy
![Semaphore Build Badge](https://edwinthinks.semaphoreci.com/badges/ex_cronofy.svg?stlye=shield "Semaphore Badge")
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/0dbbcc3d9fba46f0b5c1ca40211cd03f)](https://www.codacy.com/manual/edwinthinks/ex_cronofy?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=edwinthinks/ex_cronofy&amp;utm_campaign=Badge_Grade)

A elixir API client library to utilize [Cronofy](https://www.cronofy.com/) services to manage calendar events. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_cronofy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_cronofy, "~> 0.1.0"}
  ]
end
```

In your configuration file, add the configuration values:
```elixir
config :ex_cronofy,
  client_id: System.get_env("CRONOFY_CLIENT_ID"),
  client_secret: System.get_env("CRONOFY_CLIENT_SECRET"),
  redirect_uri: System.get_env("CRONOFY_REDIRECT_URI")
```

** Note - you don't have to use `System.get_env`. You could set these directly or however your application is setup **

## Usage

Retrieve a authorization url to give to your users to grant your application access. See more details on authorization and authentication [here](https://docs.cronofy.com/developers/api/authorization/request-authorization/).

```elixir
# Retrieve a authorization url to give to your users to grant your application access.
iex> ExCronofy.Auth.request_authorization_url("read_write")
"https://app.cronofy.com/oauth/authorize?client_id=fake_client_id&redirect_uri=fake_redirect_uri&response_type=code&scope=read_events&state=wibble"

# Retrieve access_token using the code retrieved 
iex> {:ok, response} = ExCronofy.Auth.request_access_token("random_code")
iex> response.body["access_token"] # access_token
```

See [documentation]() for more functions and methods.
