defmodule ExCronofy.Auth do
  @moduledoc """
  Provides functions to handle authorization and authentication of
  Cronofy services
  """

  @doc """
  Returns a generated request authorization url

  ## Parameters

    - scope: the path of the uri
    - redirect_uri: the redirect uri
    - options: a map of optional query parameters

  ## Examples

      iex> ExCronofy.Auth.request_authorization_url("read_events", %{state: "wibble"})
      "https://app.cronofy.com/oauth/authorize?client_id=fake_client_id&redirect_uri=fake_redirect_uri&response_type=code&scope=read_events&state=wibble"

  """
  @spec request_authorization_url(String.t(), map) :: String.t()
  def request_authorization_url(scope, options \\ %{}) do
    query_params = %{
      response_type: "code",
      scope: scope,
      client_id: Application.get_env(:ex_cronofy, :client_id),
      redirect_uri: Application.get_env(:ex_cronofy, :redirect_uri)
    }

    sanitized_query_params =
      query_params
      |> Map.merge(options)
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> URI.encode_query()

    URI.parse("https://app.cronofy.com/oauth/authorize")
    |> URI.merge(%URI{query: sanitized_query_params})
    |> URI.to_string()
  end

  @doc """
  Requests a access token from Cronofy and return the response body

  ## Parameters

    - code: a code retrieved from authorization
    - redirect_uri: the corresponding redirect_uri associated with the `code`

  ## Examples

      iex> ExCronofy.Auth.request_access_token("random_code", "http://example.com")

  """
  @spec request_access_token(String.t(), String.t()) :: tuple
  def request_access_token(code, redirect_uri) do
    ExCronofy.ApiClient.post("/oauth/token", %{
      client_id: Application.get_env(:ex_cronofy, :client_id),
      client_secret: Application.get_env(:ex_cronofy, :client_secret),
      grant_type: "authorization_code",
      code: code,
      redirect_uri: redirect_uri
    })
  end

  @doc """
  Refreshes access token

  ## Parameters

    - refresh_token: refresh token

  ## Examples

      iex> ExCronofy.Auth.refresh_access_token("random_refresh_token")

  """
  @spec refresh_access_token(String.t()) :: tuple
  def refresh_access_token(refresh_token) do
    ExCronofy.ApiClient.post("/oauth/token", %{
      client_id: Application.get_env(:ex_cronofy, :client_id),
      client_secret: Application.get_env(:ex_cronofy, :client_secret),
      grant_type: "refresh_token",
      refresh_token: refresh_token
    })
  end

  @doc """
  Revokes authorization

  ## Parameters

    - token: the token to revoke. This can be an access token or refresh token

  ## Examples

      iex> ExCronofy.Auth.revoke_authorization("random_token")

  """
  @spec revoke_authorization(String.t()) :: tuple
  def revoke_authorization(token) do
    ExCronofy.ApiClient.post("/oauth/token/revoke", %{
      client_id: Application.get_env(:ex_cronofy, :client_id),
      client_secret: Application.get_env(:ex_cronofy, :client_secret),
      token: token
    })
  end

  @doc """
  Revokes access to a profile

  ## Parameters

    - profile_id: the id of the profile to revoke access
    - access_token: an authorization token

  ## Examples

      iex> ExCronofy.Auth.revoke_profile("random_profile_id", "random_access_token")

  """
  @spec revoke_profile(String.t(), String.t()) :: tuple
  def revoke_profile(profile_id, access_token) do
    ExCronofy.ApiClient.post(
      "/v1/profiles/#{profile_id}/revoke",
      %{},
      [{"Authorization", "Bearer #{access_token}"}]
    )
  end
end
