defmodule AIGCAlpha.Core.Input do
  alias AIGCAlpha.Core.Template

  defstruct content: nil, template: %Template{}

  @type t :: %__MODULE__{
          content: String.t(),
          template: Template.t()
        }

  def new(params), do: struct!(%__MODULE__{}, params)
end
