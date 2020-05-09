defmodule ExCronofy do
  @moduledoc """
  Provides common base functions for the library client
  to function.
  """

  @base_uri "https://app.cronofy.com/"

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

  defp base_uri() do
    URI.parse(@base_uri)
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

  def handle_response({:error, %{reason: reason}}), do: {:error, reason}

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    if status_code in Enum.to_list(200..299) do
      {:ok, Poison.decode!(body)}
    else
      {:error, Poison.decode!(body)}
    end
  end
end
