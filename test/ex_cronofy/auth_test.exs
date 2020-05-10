defmodule ExCronofy.AuthTest do
  use ExUnit.Case

  import Mock

  alias ExCronofy.{ApiClient, Auth}

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
        Auth.request_authorization_url(
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
    test "sends API request to properly and returns ok with response" do
      code = Faker.String.base64()
      redirect_uri = Faker.Internet.url()

      path = "/oauth/token"

      request_body = %{
        client_id: Application.get_env(:ex_cronofy, :client_id),
        client_secret: Application.get_env(:ex_cronofy, :client_secret),
        grant_type: "authorization_code",
        code: code,
        redirect_uri: redirect_uri
      }

      fake_response = Faker.String.base64()

      with_mock ApiClient, post: fn ^path, ^request_body -> {:ok, fake_response} end do
        assert {:ok, fake_response} == Auth.request_access_token(code, redirect_uri)
      end
    end
  end

  describe "refresh_access_token/1" do
    test "sends API request to properly and returns ok with response" do
      refresh_token = Faker.String.base64()

      path = "/oauth/token"

      request_body = %{
        client_id: Application.get_env(:ex_cronofy, :client_id),
        client_secret: Application.get_env(:ex_cronofy, :client_secret),
        grant_type: "refresh_token",
        refresh_token: refresh_token
      }

      fake_response = Faker.String.base64()

      with_mock ApiClient, post: fn ^path, ^request_body -> {:ok, fake_response} end do
        assert {:ok, fake_response} == Auth.refresh_access_token(refresh_token)
      end
    end
  end

  describe "revoke_authorization/1" do
    test "sends API request to properly and returns ok with response" do
      token = Faker.String.base64()

      path = "/oauth/token/revoke"

      request_body = %{
        client_id: Application.get_env(:ex_cronofy, :client_id),
        client_secret: Application.get_env(:ex_cronofy, :client_secret),
        token: token
      }

      fake_response = Faker.String.base64()

      with_mock ApiClient, post: fn ^path, ^request_body -> {:ok, fake_response} end do
        assert {:ok, fake_response} == Auth.revoke_authorization(token)
      end
    end
  end

  describe "revoke_profile/2" do
    test "sends API request to properly and returns ok with response" do
      profile_id = Faker.String.base64()
      access_token = Faker.String.base64()

      path = "/v1/profiles/#{profile_id}/revoke"
      request_body = %{}

      fake_response = Faker.String.base64()

      headers = [{"Authorization", "Bearer #{access_token}"}]

      with_mock ApiClient,
        post: fn ^path, ^request_body, ^headers -> {:ok, fake_response} end do
        assert {:ok, fake_response} == Auth.revoke_profile(profile_id, access_token)
      end
    end
  end
end
