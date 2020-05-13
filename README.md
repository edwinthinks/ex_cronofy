# ExCronofy
![Semaphore Build Badge](https://edwinthinks.semaphoreci.com/badges/ex_cronofy.svg?stlye=shield "Semaphore Badge")
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/0dbbcc3d9fba46f0b5c1ca40211cd03f)](https://www.codacy.com/manual/edwinthinks/ex_cronofy?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=edwinthinks/ex_cronofy&amp;utm_campaign=Badge_Grade)
[![Coverage Status](https://coveralls.io/repos/github/edwinthinks/ex_cronofy/badge.svg?branch=master)](https://coveralls.io/github/edwinthinks/ex_cronofy?branch=master)

A elixir API client library to utilize [Cronofy](https://www.cronofy.com/) services to manage calendar events! With this library you can programmatically read and create calendar events.

![alt text](https://media.giphy.com/media/eHEmsqSW9B53K65dnS/source.gif "Logo Title Text 1")

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

**Note - you don't have to use `System.get_env`. You could set these directly or however your application is setup**

## Usage

**Note - the response data used below are all examples and not real. Primarily used to generate expected output. Check [cronofy API documentation](https://docs.cronofy.com/developers/api/) for more info**

#### Getting An Access Token
Retrieve a authorization url to give to your users to grant your application access for a
particular `scope`. See more options [here](https://docs.cronofy.com/developers/api/authorization/request-authorization/)

```elixir
iex> scope = "read_write"
iex> ExCronofy.Auth.request_authorization_url(scope)
"https://app.cronofy.com/oauth/authorize?client_id=fake_client_id&redirect_uri=fake_redirect_uri&response_type=code&scope=read_events&state=wibble"
```

Fetch a access token using the query parameter provided on the redirect after a user authorizes your application from the authorization url above.

```elixir
# Retrieve access_token using the code retrieved 
iex> {:ok, response} = ExCronofy.Auth.request_access_token("random_code")
{:ok,
 %HTTPoison.Response{
   body: %{
     "access_token" => "533P-rf-Xl3339ER33uijYb339gTjP9-",
     "account_id" => "ac11_5eb1ef333333330c0220",
     "expires_in" => 10800,
     "linking_profile" => %{
       "profile_id" => "pro_1150Q333Bz22-",
       "profile_name" => "john@example.com",
       "provider_name" => "google"
     },
     "refresh_token" => "RD22-G22f333B9_mXwI-hvW223",
     "scope" => "read_write",
     "sub" => "acc_5eb1e222607a902222230",
     "token_type" => "bearer"
   },
   headers: [
     {"Date", "Wed, 13 May 2020 01:57:18 GMT"},
     {"Content-Type", "application/json; charset=utf-8"},
     {"Transfer-Encoding", "chunked"},
     {"Connection", "keep-alive"},
     {"Status", "200 OK"},
     {"Cache-Control", "no-cache, no-store, max-age=0, must-revalidate"},
     {"Vary", "Accept-Encoding"},
     {"Strict-Transport-Security", "max-age=31536000"},
     {"Pragma", "no-cache"},
     {"X-XSS-Protection", "1; mode=block"},
     {"X-Request-Id", "635abd31-264f-49ae-9e5b-1c9ecc04c5b2"},
     {"X-Runtime", "0.113007"},
     {"X-Frame-Options", "SAMEORIGIN"},
     {"X-Content-Type-Options", "nosniff"},
     {"X-Powered-By", "Phusion Passenger"},
     {"Server", "nginx + Phusion Passenger"}
   ],
   request: %HTTPoison.Request{
     body: "{\"redirect_uri\":\"http://localhost:3000\",\"grant_type\":\"authorization_code\",\"code\":\"....\",\"client_secret\":\".....\",\"client_id\":\".....\"}",
     headers: [{"Content-Type", "application/json"}],
     method: :post,
     options: [],
     params: %{},
     url: "https://api.cronofy.com/oauth/token"
   },
   request_url: "https://api.cronofy.com/oauth/token",
   status_code: 200
 }}
iex> response.body["access_token"]
"533P-rf-Xl3339ER33uijYb339gTjP9-"
```

#### Retrieving Calendars For a User
```elixir
iex> access_token = "...."
iex> {:ok, response} = ExCronofy.Calendars.list_calendars(access_token)
{:ok,
 %HTTPoison.Response{
   body: %{
     "calendars" => [
       %{
         "calendar_deleted" => false,
         "calendar_id" => "...",
         "calendar_name" => "john@example.com",
         "calendar_primary" => true,
         "calendar_readonly" => false,
         "permission_level" => "sandbox",
         "profile_id" => "...",
         "profile_name" => "john@example.com",
         "provider_name" => "google"
       },
       ...
     ]
   },
   headers: [
     {"Date", "Wed, 13 May 2020 11:40:34 GMT"},
     {"Content-Type", "application/json; charset=utf-8"},
     {"Transfer-Encoding", "chunked"},
     {"Connection", "keep-alive"},
     {"Status", "200 OK"},
     {"Cache-Control", "max-age=0, private, must-revalidate"},
     {"Vary", "Accept-Encoding"},
     {"Strict-Transport-Security", "max-age=31536000"},
     {"X-XSS-Protection", "1; mode=block"},
     {"X-Request-Id", "36aca0ec-8850-4bc6-b3c9-75858f5b5247"},
     {"ETag", "W/\"447d4b1ac51eab108ee8e6a12bad6ce3\""},
     {"X-Frame-Options", "SAMEORIGIN"},
     {"X-Runtime", "0.086018"},
     {"X-Content-Type-Options", "nosniff"},
     {"X-Powered-By", "Phusion Passenger"},
     {"Server", "nginx + Phusion Passenger"}
   ],
   request: %HTTPoison.Request{
     body: "",
     headers: [
       {"Content-Type", "application/json"},
       {"Authorization", "Bearer ...."}
     ],
     method: :get,
     options: [],
     params: %{},
     url: "https://api.cronofy.com/v1/calendars"
   },
   request_url: "https://api.cronofy.com/v1/calendars",
   status_code: 200
 }}
```

#### See [documentation]() for more available functions and methods.

## Contributing

Please open up a issue if you have found a bug or want to suggest some improvements. Pull requests are also very welcome!

