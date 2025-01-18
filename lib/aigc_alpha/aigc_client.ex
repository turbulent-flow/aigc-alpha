defmodule AIGCAlpha.AIGCClient do
  alias AIGCAlpha.Core.Input
  alias AIGCAlpha.Core.Output
  alias AIGCAlpha.AIGCClient.Error

  @callback inquire(Input.t()) :: {:ok, Output.t()} | {:error, Error.t()}

  def inquire(input), do: impl(:inquire, [input])

  defp impl(func, args) do
    Application.fetch_env!(:aigc_alpha, :aigc_client)
    |> Keyword.fetch!(:adapter)
    |> apply(func, args)
  end
end
