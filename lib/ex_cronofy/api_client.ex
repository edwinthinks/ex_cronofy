defmodule ExCronofy.ApiClient do
  @moduledoc """
  An HTTPoison client wrapped to process API http requests to Cronofy
  """

  use HTTPoison.Base

  def process_request_url(url) do
    "https://api.cronofy.com" <> url
  end

  def process_response_body(body) when is_binary(body) do
    if body == "" do
      %{}
    else
      {:ok, parsed_body} = body |> Poison.Parser.parse()

      parsed_body
    end
  end

  def process_request_body(""), do: ""

  def process_request_body(request_body) when is_map(request_body) do
    Poison.encode!(request_body)
  end

  def process_request_headers(headers) do
    [{"Content-Type", "application/json"} | headers]
  end
end
