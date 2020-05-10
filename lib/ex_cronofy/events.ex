defmodule ExCronofy.Events do
  @moduledoc """
  Provides functions to interact with Cronofy's events API
  """

  alias ExCronofy.ApiClient

  @doc """
  Sends a request to get a list the calendars for a authenticated user

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
end
