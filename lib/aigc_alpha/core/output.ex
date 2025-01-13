defmodule AIGCAlpha.Core.Output do
  defstruct [:content]

  @type t :: %__MODULE__{
          content: String.t()
        }

  def new(params), do: struct!(%__MODULE__{}, params)
end
