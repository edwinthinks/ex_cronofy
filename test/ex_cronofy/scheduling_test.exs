defmodule ExCronofy.SchedulingTest do
  use ExUnit.Case

  import Mock

  alias ExCronofy.{ApiClient, Scheduling}

  describe "get_availablity/1" do
    test "sends API request to properly and returns ok with response" do
      availability_params = %{
        participants: [
          %{
            members: [
              %{
                sub: Faker.String.base64(),
                calendar_ids: [Faker.String.base64()]
              }
            ]
          }
        ],
        required: "all"
      }

      path = "/v1/availability"

      fake_response = Faker.String.base64()
      headers = [{"Authorization", "Bearer #{Application.get_env(:ex_cronofy, :client_secret)}"}]

      with_mock ApiClient,
        post: fn ^path, ^availability_params, ^headers -> {:ok, fake_response} end do
        assert {:ok, fake_response} ==
                 Scheduling.get_availablity(availability_params)
      end
    end
  end
end
