defmodule ExCronofy.Auth do
  import ExCronofy

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
