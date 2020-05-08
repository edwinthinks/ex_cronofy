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
    test "handles success and returns ok with body" do
      response = %{
        "status_code" => 200,
        "body" => %{
          "data" => Faker.String.base64()
        }
      }

      assert {:ok, response["body"]} == ExCronofy.handle_response({:ok, Poison.encode!(response)})
    end

    test "handles 400 error with error and error message" do
      response = %{
        "status_code" => 400,
        "body" => %{
          "error" => Faker.String.base64()
        }
      }

      assert {:error, response["body"]} ==
               ExCronofy.handle_response({:ok, Poison.encode!(response)})
    end
  end
end
