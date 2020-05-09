defmodule ExCronofyTest do
  use ExUnit.Case
  doctest ExCronofy

  describe "fetch_uri/2" do
    test "generates path with query parameters" do
      path = "/test"

      query_params = %{
        "a" => Faker.String.base64(),
        "b" => Faker.String.base64()
      }

      resultant_uri =
        ExCronofy.fetch_uri(path, query_params)
        |> URI.parse()

      assert URI.decode_query(resultant_uri.query) == query_params

      assert "#{resultant_uri.scheme}://#{resultant_uri.host}#{resultant_uri.path}" ==
               "https://app.cronofy.com#{path}"
    end

    test "generates path without query parameters" do
      path = "/test"

      resultant_uri = ExCronofy.fetch_uri(path)
      assert resultant_uri == "https://app.cronofy.com#{path}"
    end
  end

  describe "handle_response/1" do
    test "handles error and return :error with reason" do
      reason = Faker.String.base64()
      assert {:error, reason} == ExCronofy.handle_response({:error, %{reason: reason}})
    end

    test "handles 200 success and return :ok with body" do
      body = %{"data" => Faker.String.base64()}

      response = %{
        status_code: 200,
        body: Poison.encode!(body)
      }

      assert {:ok, body} == ExCronofy.handle_response({:ok, response})
    end

    test "handles non 200 and returns :error with body" do
      body = %{"data" => Faker.String.base64()}

      response = %{
        status_code: 400,
        body: Poison.encode!(body)
      }

      assert {:error, body} == ExCronofy.handle_response({:ok, response})
    end
  end
end
