defmodule ExCronofy.AuthTest do
  use ExUnit.Case
  doctest ExCronofy.Auth

  import Mock

  describe "request_authorization_url/2" do
    test "returns authorization uri with correct query params" do
      required_query_params = %{
        response_type: "code",
        redirect_uri: Application.get_env(:ex_cronofy, :redirect_uri),
        client_id: Application.get_env(:ex_cronofy, :client_id),
        scope: Faker.String.base64()
      }

      optional_params = %{
        state: Faker.String.base64()
      }

      resultant_uri =
        ExCronofy.Auth.request_authorization_url(
          required_query_params.scope,
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

  describe "request_access_token/2" do
    test "returns ok and body on 200 success" do
      code = Faker.String.base64()
      redirect_uri = Faker.Internet.url()

      uri = ExCronofy.fetch_uri("/oauth/token")

      body =
        Poison.encode!(%{
          client_id: Application.get_env(:ex_cronofy, :client_id),
          client_secret: Application.get_env(:ex_cronofy, :client_secret),
          grant_type: "authorization_code",
          code: code,
          redirect_uri: redirect_uri
        })

      success_response = %{
        status_code: 200,
        body:
          Poison.encode!(%{
            data: Faker.String.base64()
          })
      }

      with_mock HTTPoison,
        post: fn ^uri, ^body, [{"Content-Type", "application/json"}] ->
          {:ok, success_response}
        end do
        decoded_body = Poison.decode!(success_response.body)

        assert {:ok, decoded_body} ==
                 ExCronofy.Auth.request_access_token(code, redirect_uri)
      end
    end

    test "returns error and message on 400 error" do
      code = Faker.String.base64()
      redirect_uri = Faker.Internet.url()

      uri = ExCronofy.fetch_uri("/oauth/token")

      body =
        Poison.encode!(%{
          client_id: Application.get_env(:ex_cronofy, :client_id),
          client_secret: Application.get_env(:ex_cronofy, :client_secret),
          grant_type: "authorization_code",
          code: code,
          redirect_uri: redirect_uri
        })

      error_msg = Faker.String.base64()

      failure_response = %{
        status_code: 400,
        body:
          Poison.encode!(%{
            error: error_msg
          })
      }

      with_mock HTTPoison,
        post: fn ^uri, ^body, [{"Content-Type", "application/json"}] ->
          {:ok, failure_response}
        end do
        assert {:error, %{"error" => error_msg}} ==
                 ExCronofy.Auth.request_access_token(code, redirect_uri)
      end
    end
  end
end
