defmodule ExCronofy do
  @moduledoc """
  Provides common base functions for the library client
  to function.
  """

  @base_uri "https://app.cronofy.com/"
  @api_base_uri "https://api.cronofy.com/"
  @default_headers [{"Content-Type", "application/json"}]

  @doc """
  Generates and returns a cronofy URI

  ## Parameters

    - path: the path of the uri
    - query_params: a map of query parameters

  ## Examples

      iex> ExCronofy.fetch_uri("/test", %{a: "test"})
      "https://app.cronofy.com/test?a=test"

  """
  @spec fetch_uri(String.t(), map) :: String.t()
  def fetch_uri(path, query_params \\ %{}) do
    base_uri()
    |> add_uri_path(path)
    |> add_uri_query_parameters(query_params)
    |> URI.to_string()
  end

  @spec fetch_api_uri(String.t()) :: String.t()
  def fetch_api_uri(path) do
    api_base_uri()
    |> add_uri_path(path)
    |> URI.to_string()
  end

  defp base_uri() do
    URI.parse(@base_uri)
  end

  defp api_base_uri() do
    URI.parse(@api_base_uri)
  end

  defp add_uri_path(uri, path) do
    uri
    |> URI.merge(%URI{path: path})
  end

  defp add_uri_query_parameters(uri, query_params) when query_params == %{}, do: uri

  defp add_uri_query_parameters(uri, query_params) do
    sanitized_query_params =
      query_params
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> URI.encode_query()

    uri
    |> URI.merge(%URI{query: sanitized_query_params})
  end

  @doc """
  Returns proper response from a cronofy HTTP request

  ## Examples

      iex> ExCronofy.handle_api_response({:error, %{reason: "test"}})
      {:error, "test"}

      iex> data = Poison.encode!(%{data: "ok"})
      iex> ExCronofy.handle_api_response({:ok, %{status_code: 200, body: data}})
      {:ok, %{"data" => "ok"}}

      iex> data = Poison.encode!(%{message: "ok"})
      iex> ExCronofy.handle_api_response({:ok, %{status_code: 400, body: data}})
      {:error, %{"message" => "ok"}}


  """
  def handle_api_response({:error, %{reason: reason}}), do: {:error, reason}

  def handle_api_response({:ok, %{status_code: status_code, body: body}}) do
    if success_code?(status_code) do
      {:ok, body |> handle_body()}
    else
      {:error, body |> handle_body()}
    end
  end

  defp handle_body(body) do
    if body == "" do
      nil
    else
      Poison.decode!(body)
    end
  end

  defp success_code?(status_code) do
    status_code in Enum.to_list(200..299)
  end
end
