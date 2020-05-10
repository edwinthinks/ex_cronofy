defmodule ExCronofy.Scheduling do
  @moduledoc """
  Provides functions to interact with Cronofy's scheduling API
  """

  alias ExCronofy.ApiClient

  @doc """
  Sends a request to get a list the calendars for a authenticated user

  ## Parameters

    - availability_params: parameters to determine common availability for people. See [here](https://docs.cronofy.com/developers/api/scheduling/availability/) for options

  ## Examples
      iex> availability_param = %{...}
      iex> ExCronofy.Scheduling.get_availablity(availability_param, "random_access_token")
  """
  @spec get_availablity(map) :: tuple
  def get_availablity(availability_params) do
    ApiClient.post("/v1/availability", availability_params, [
      {"Authorization", "Bearer #{Application.get_env(:ex_cronofy, :client_secret)}"}
    ])
  end
end
