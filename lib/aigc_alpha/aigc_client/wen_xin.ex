defmodule AIGCAlpha.AIGCClient.WenXin do
  require Logger

  alias AIGCAlpha.AIGCClient.Error
  alias AIGCAlpha.AIGCClient
  alias AIGCAlpha.Core.Output

  @behaviour AIGCClient

  @spec inquire(
          atom()
          | %{
              :content => any(),
              :template => atom() | %{:content => binary(), optional(any()) => any()},
              optional(any()) => any()
            }
        ) :: {:error, struct()} | {:ok, struct()}
  def inquire(input) do
    with params <- normalize(input),
         {:ok, result} <- Tesla.post(client(), inquire_path(), params),
         :ok <- validate(result),
         content <- normalize_content(result.body) do
      {:ok, Output.new(%{content: content})}
    else
      {:error, error_data} ->
        error_params = %{
          status: error_data.status,
          params: input,
          details: error_data.details
        }

        error_struct = Error.new(error_params)

        Logger.error(
          ~s[Call AIGCAlpha.AIGCClient.inquire/1 failed, as the reason is #{inspect(error_struct)}.]
        )

        {:error, error_struct}
    end
  end

  defp normalize_content(data) do
    data
    |> Map.fetch!("choices")
    |> hd()
    |> Map.fetch!("message")
    |> Map.fetch!("content")
  end

  defp validate(%Tesla.Env{status: 200}), do: :ok

  defp validate(%Tesla.Env{status: status, body: body}) do
    error_data = %{
      status: status,
      details: body
    }

    {:error, error_data}
  end

  defp client do
    [basic_url: basic_url()]
    |> middlewares()
    |> Tesla.client()
  end

  defp middlewares(opts) do
    basic_url = Keyword.fetch!(opts, :basic_url)

    [
      {Tesla.Middleware.BaseUrl, basic_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"authorization", "Bearer #{api_key()}"}
       ]}
    ]
  end

  defp normalize(input) do
    pattern = ~r/{.*?}/
    raw = input.template.content
    replacement = input.content

    pattern
    |> Regex.replace(raw, fn _, _ -> "{#{replacement}}" end)
    |> normalize_params()
  end

  defp normalize_params(content),
    do: %{
      model: model(),
      messages: [
        %{
          role: :user,
          content: content
        }
      ]
    }

  defp inquire_path do
    Application.fetch_env!(:aigc_alpha, :wen_xin)
    |> Keyword.fetch!(:inquire_path)
  end

  defp api_key do
    Application.fetch_env!(:aigc_alpha, :wen_xin)
    |> Keyword.fetch!(:api_key)
  end

  defp basic_url do
    Application.fetch_env!(:aigc_alpha, :wen_xin)
    |> Keyword.fetch!(:basic_url)
  end

  defp model do
    Application.fetch_env!(:aigc_alpha, :wen_xin)
    |> Keyword.fetch!(:model)
  end
end
