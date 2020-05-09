defmodule ExCronofy.ApiClient do
  use HTTPoison.Base

  def process_request_url(url) do
    "https://api.cronofy.com" <> url
  end

  def process_response_body(body) when is_binary(body) do
    body |> Poison.decode!()
  end

  def process_response_body(body) when body == "", do: %{}

  def process_request_body(""), do: ""

  def process_request_body(request_body) when is_map(request_body) do
    Poison.encode!(request_body)
  end

  def process_request_headers(headers) do
    [{"Content-Type", "application/json"} | headers]
  end
end
