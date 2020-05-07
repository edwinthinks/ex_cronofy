defmodule ExCronofy.Auth do
  @moduledoc """
  Provides functions to handle authorization and authentication of
  cronofy services
  """

  @doc """
  Returns a generated request authorization url

  ## Parameters

    - scope: the path of the uri
    - redirect_uri: the redirect uri
    - options: a map of optional query parameters

  ## Examples

      iex> ExCronofy.Auth.request_authorization_url("/test", "/redirect-test", %{a: "test"})
      "https://app.cronofy.com/oauth/authorize?a=test&client_id=fake_client_id&redirect_uri=%2Fredirect-test&response_type=code&scope=%2Ftest"

  """
  @spec request_authorization_url(String.t(), String.t(), map) :: String.t()
  def request_authorization_url(scope, redirect_uri, options \\ %{}) do
    query_params =
      %{
        response_type: "code",
        redirect_uri: redirect_uri,
        scope: scope,
        client_id: Application.get_env(:ex_cronofy, :client_id)
      }
      |> Map.merge(options)

    ExCronofy.fetch_uri("/oauth/authorize", query_params)
  end
end
