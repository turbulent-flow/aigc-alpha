defmodule AIGCAlpha.AIGCClient.Error do
  alias AIGCAlpha.Core.Input
  alias AIGCAlpha.AIGCClient.WenXin

  defstruct status: 400, adapter: WenXin, params: %Input{}, details: nil

  @type t :: %__MODULE__{
          status: integer(),
          adapter: atom(),
          params: Input.t(),
          details: any()
        }

  def new(params), do: struct!(%__MODULE__{}, params)
end
