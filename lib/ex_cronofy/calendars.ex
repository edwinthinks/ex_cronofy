defmodule ExCronofy.Calendars do
  @moduledoc """
  Provides functions to interact with Cronofy's calendar API
  """

  alias ExCronofy.ApiClient

  @doc """
  Sends a request to get a list the calendars for a authenticated user

  ## Parameters

    - access_token: an authorization token

  ## Examples

      iex> ExCronofy.Calendars.list_calendars("random_access_token")
  """
  @spec list_calendars(String.t()) :: tuple
  def list_calendars(access_token) do
    ApiClient.get("/v1/calendars", [{"Authorization", "Bearer #{access_token}"}])
  end

  @doc """
  Sends a request to create a calendar for a authenticated user

  ## Parameters

    - calendar_attrs: attributes you can set on the calendar. Look at [API document here](https://docs.cronofy.com/developers/api/calendars/create-calendar/) to see options
    - access_token: an authorization token

  ## Examples

      iex> ExCronofy.Calendars.create_calendar(%{profile_id: "wibble", name: "wobble"}, "random_access_token")
  """
  @spec create_calendar(map, String.t()) :: tuple
  def create_calendar(calendar_attrs, access_token) do
    ApiClient.post("/v1/calendars", calendar_attrs, [
      {"Authorization", "Bearer #{access_token}"}
    ])
  end

  @doc """
  Sends a request to provision a Cronofy hosted calendar for your application

  ## Parameters

    - application_calendar_id: a unique string to identify your application calendar

  ## Examples

      iex> ExCronofy.Calendars.create_application_calendar("wibble")
  """
  @spec create_application_calendar(String.t()) :: tuple
  def create_application_calendar(application_calendar_id) do
    request_body = %{
      client_id: Application.get_env(:ex_cronofy, :client_id),
      client_secret: Application.get_env(:ex_cronofy, :client_secret),
      application_calendar_id: application_calendar_id
    }

    ApiClient.post("/v1/application_calendars", request_body)
  end
end
