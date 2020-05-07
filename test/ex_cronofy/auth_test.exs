defmodule ExCronofy.AuthTest do
  use ExUnit.Case
  doctest ExCronofy.Auth

  describe "request_authorization_url/3" do
    test "returns authorization uri with correct query params" do
      required_query_params = %{
        response_type: "code",
        redirect_uri: Faker.String.base64(),
        client_id: Application.get_env(:ex_cronofy, :client_id),
        scope: Faker.String.base64()
      }

      optional_params = %{
        state: Faker.String.base64()
      }

      resultant_uri =
        ExCronofy.Auth.request_authorization_url(
          required_query_params.scope,
          required_query_params.redirect_uri,
          optional_params
        )

      resultant_uri =
        resultant_uri
        |> URI.parse()

      assert "#{resultant_uri.scheme}://#{resultant_uri.host}#{resultant_uri.path}" ==
               "https://app.cronofy.com/oauth/authorize"

      expected_query_params =
        Map.merge(required_query_params, optional_params)
        |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)

      assert expected_query_params == URI.decode_query(resultant_uri.query)
    end
  end
end
