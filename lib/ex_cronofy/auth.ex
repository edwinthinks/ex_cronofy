defmodule ExCronofy.Auth do
  @moduledoc """
  Provides functions to handle authorization and authentication of
  cronofy services
  """

  @redirect_uri Application.get_env(:ex_cronofy, :redirect_uri)
  @client_id Application.get_env(:ex_cronofy, :client_id)
  @client_secret Application.get_env(:ex_cronofy, :client_secret)

  @doc """
  Returns a generated request authorization url

  ## Parameters

    - scope: the path of the uri
    - redirect_uri: the redirect uri
    - options: a map of optional query parameters

  ## Examples

      iex> ExCronofy.Auth.request_authorization_url("/test", %{a: "test"})
      "https://app.cronofy.com/oauth/authorize?a=test&client_id=fake_client_id&redirect_uri=fake_redirect_uri&response_type=code&scope=%2Ftest"

  """
  @spec request_authorization_url(String.t(), map) :: String.t()
  def request_authorization_url(scope, options \\ %{}) do
    query_params =
      %{
        response_type: "code",
        redirect_uri: @redirect_uri,
        scope: scope,
        client_id: @client_id
      }
      |> Map.merge(options)

    ExCronofy.fetch_uri("/oauth/authorize", query_params)
  end

  @doc """
  Requests a access token from Cronofy and return the response body

  ## Parameters

    - code: a code retrieved from authorization
    - redirect_uri: the corresponding redirect_uri associated with the `code`
  """
  @spec request_access_token(String.t(), String.t()) :: tuple
  def request_access_token(code, redirect_uri) do
    ExCronofy.fetch_api_uri("/oauth/token")
    |> HTTPoison.post(
      Poison.encode!(%{
        client_id: @client_id,
        client_secret: @client_secret,
        grant_type: "authorization_code",
        code: code,
        redirect_uri: redirect_uri
      }),
      [{"Content-Type", "application/json"}]
    )
    |> ExCronofy.handle_api_response()
  end

  @doc """
  Refreshes access token

  ## Parameters

    - refresh_token: refresh token
  """
  @spec refresh_access_token(String.t()) :: tuple
  def refresh_access_token(refresh_token) do
    ExCronofy.fetch_api_uri("/oauth/token")
    |> HTTPoison.post(
      Poison.encode!(%{
        client_id: @client_id,
        client_secret: @client_secret,
        grant_type: "refresh_token",
        refresh_token: refresh_token
      }),
      [{"Content-Type", "application/json"}]
    )
    |> ExCronofy.handle_api_response()
  end

  @doc """
  Revokes authorization

  ## Parameters

    - token: the token to revoke. This can be an access token or refresh token
  """
  @spec revoke_authorization(String.t()) :: tuple
  def revoke_authorization(token) do
    ExCronofy.fetch_api_uri("/oauth/token/revoke")
    |> HTTPoison.post(
      Poison.encode!(%{
        client_id: @client_id,
        client_secret: @client_secret,
        token: token
      }),
      [{"Content-Type", "application/json"}]
    )
    |> ExCronofy.handle_api_response()
  end

  @doc """
  Revokes access to a profile

  ## Parameters

    - profile_id: the id of the profile to revoke access
    - access_token: an authorization token
  """
  @spec revoke_profile(String.t(), String.t()) :: tuple
  def revoke_profile(profile_id, access_token) do
    ExCronofy.fetch_api_uri("/v1/profiles/#{profile_id}/revoke")
    |> HTTPoison.post("", [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{access_token}"}
    ])
    |> ExCronofy.handle_api_response()
  end
end
