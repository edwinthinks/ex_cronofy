defmodule ExCronofy.Events do
  @moduledoc """
  Provides functions to interact with Cronofy's events API
  """

  alias ExCronofy.ApiClient

  @doc """
  Gets a list of events across calendars for a authenticated user

  ## Parameters

    - query_params.tzid: the timezone to return event results. Must be a [IANA compliant timezone](https://www.iana.org/time-zones)
    - query_params.from: the maximum date from which to return events
    - query_params.from: the minimum date from which to return events
    - availability_params: parameters to determine common availability for people. See [here](https://docs.cronofy.com/developers/api/scheduling/availability/) for options

  ## Examples
      iex> query_params = %{from: "2020-05-08", to: "2020-05-13", tzid: "Etc/UTC"}
      iex> ExCronofy.Events.read_events(query_params, "random_access_token")
  """
  @spec read_events(map, String.t()) :: tuple
  def read_events(%{tzid: _tzid} = query_params, access_token) do
    path = "/v1/events?" <> URI.encode_query(query_params)

    ApiClient.get(path, [
      {"Authorization", "Bearer #{access_token}"}
    ])
  end

  @doc """
  Creates or updates a event on a calendar_id

  ## Parameters

    - calendar_id: an id of the calendar
    - event_attrs: details about the event to be created or updated
    - access_token: a access token

  ## Examples
      
      iex> calendar_id = "wibble"
      iex> event_attrs = %{
        description: "Discuss plans for the next quarter.",
        end: "2020-05-12T17:00:00Z",
        event_id: "qTtZdczOccgaPncGJaCiLg",
        location: %{
          description: "Board room"
        },
        start: "2020-05-12T15:30:00Z",
        summary: "Board meeting"
      }
      iex> ExCronofy.Events.create_or_update_event(calendar_id, event_attrs, "random_access_token")

  """
  @spec create_or_update_event(String.t(), map, String.t()) :: tuple
  def create_or_update_event(calendar_id, event_attrs, access_token) do
    path = "/v1/calendars/#{calendar_id}/events"

    ApiClient.post(path, event_attrs, [
      {"Authorization", "Bearer #{access_token}"}
    ])
  end
end
