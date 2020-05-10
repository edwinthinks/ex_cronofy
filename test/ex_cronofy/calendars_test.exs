defmodule ExCronofy.CalendarsTest do
  use ExUnit.Case

  import Mock

  describe "list_calendars/1" do
    test "sends API request to properly and returns ok with response" do
      access_token = Faker.String.base64()

      path = "/v1/calendars"

      fake_response = Faker.String.base64()
      headers = [{"Authorization", "Bearer #{access_token}"}]

      with_mock ExCronofy.ApiClient, get: fn ^path, ^headers -> {:ok, fake_response} end do
        assert {:ok, fake_response} == ExCronofy.Calendars.list_calendars(access_token)
      end
    end
  end

  describe "create_calendar/2" do
    test "sends API request to properly and returns ok with response" do
      access_token = Faker.String.base64()

      calendar_attrs = %{
        profile_id: Faker.String.base64(),
        name: Faker.String.base64()
      }

      path = "/v1/calendars"

      fake_response = Faker.String.base64()
      headers = [{"Authorization", "Bearer #{access_token}"}]

      with_mock ExCronofy.ApiClient,
        post: fn ^path, ^calendar_attrs, ^headers -> {:ok, fake_response} end do
        assert {:ok, fake_response} ==
                 ExCronofy.Calendars.create_calendar(calendar_attrs, access_token)
      end
    end
  end

  describe "create_application_calendar/2" do
    test "sends API request to properly and returns ok with response" do
      application_calendar_id = Faker.String.base64()

      request_body = %{
        client_id: Application.get_env(:ex_cronofy, :client_id),
        client_secret: Application.get_env(:ex_cronofy, :client_secret),
        application_calendar_id: application_calendar_id
      }

      path = "/v1/application_calendars"

      fake_response = Faker.String.base64()

      with_mock ExCronofy.ApiClient, post: fn ^path, ^request_body -> {:ok, fake_response} end do
        assert {:ok, fake_response} ==
                 ExCronofy.Calendars.create_application_calendar(application_calendar_id)
      end
    end
  end
end
