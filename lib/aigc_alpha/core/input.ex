defmodule AIGCAlpha.Core.Input do
  alias AIGCAlpha.Core.Template

  @derive Jason.Encoder
  defstruct content: nil, template: %Template{}

  @type t :: %__MODULE__{
          content: String.t() | nil,
          template: Template.t()
        }

  def new(params), do: struct!(%__MODULE__{}, params)
end
