defmodule AIGCAlpha.AigcClient.WenXinTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias AIGCAlpha.AIGCClient.WenXin
  alias AIGCAlpha.AIGCClient.Error
  alias AIGCAlpha.Core.Input
  alias AIGCAlpha.Core.Template
  alias AIGCAlpha.Core.Output

  describe "AIGCClient.WenXin.inquire/1" do
    setup [:create_url, :create_params]

    test "should return an answer from LLM", %{url: url, params: params} do
      input = Input.new(params)

      mock(fn %{method: :post, url: ^url, body: params} ->
        %{
          "model" => "fake-model",
          "messages" => [
            %{
              "role" => "user",
              "content" => "请把大括号中的中文翻译成英文，{你好，我是岚岚！}。"
            }
          ]
        } = params |> Jason.decode!()

        %Tesla.Env{
          status: 200,
          body: %{
            "id" => "fake-id",
            "model" => "fake-model",
            "choices" => [
              %{
                "message" => %{
                  "role" => "assistant",
                  "content" => "Hello, I'm Lanlan!"
                }
              }
            ]
          }
        }
      end)

      {:ok, output} = WenXin.inquire(input)

      assert %Output{
               content: "Hello, I'm Lanlan!"
             } = output
    end

    test "should return an error", %{url: url, params: params} do
      error_details = %{
        "error" => %{
          "code" => "invalid_iam_token",
          "message" => "IAM Certification failed",
          "type" => "invalid_request_error"
        },
        "id" => "fake-id"
      }

      mock(fn %{method: :post, url: ^url} ->
        %Tesla.Env{
          status: 401,
          body: error_details
        }
      end)

      input = Input.new(params)
      {:error, error_data} = WenXin.inquire(input)

      assert %Error{
               status: 401,
               params: ^input,
               details: ^error_details
             } = error_data
    end
  end

  defp create_params(_),
    do: %{
      params: %{
        content: "你好，我是岚岚！",
        template:
          Template.new(%{
            type: :translate_to_en,
            content: "请把大括号中的中文翻译成英文，{xxxxx}。"
          })
      }
    }

  defp create_url(_), do: %{url: "https://example.com/fake-path"}
end
