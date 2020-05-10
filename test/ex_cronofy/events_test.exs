defmodule ExCronofy.EventsTest do
  use ExUnit.Case

  import Mock

  alias ExCronofy.{ApiClient, Events}

  describe "read_events/2" do
    test "raises FunctionClauseError when tzid is not provided in query_params" do
      access_token = Faker.String.base64()

      invalid_query_params = %{}

      assert_raise FunctionClauseError, fn ->
        Events.read_events(invalid_query_params, access_token)
      end
    end

    test "sends API request to properly with query params and returns ok with response" do
      access_token = Faker.String.base64()

      query_params = %{
        tzid: "Etc/UTC",
        from: Faker.Date.backward(5) |> Date.to_string(),
        to: Faker.Date.forward(5) |> Date.to_string()
      }

      path = "/v1/events?" <> URI.encode_query(query_params)

      fake_response = Faker.String.base64()
      headers = [{"Authorization", "Bearer #{access_token}"}]

      with_mock ApiClient, get: fn ^path, ^headers -> {:ok, fake_response} end do
        assert {:ok, fake_response} == Events.read_events(query_params, access_token)
      end
    end
  end
end
