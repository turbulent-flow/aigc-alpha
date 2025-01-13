defmodule AIGCAlpha.Core.Template do
  defstruct type: :translate_to_en, content: "请把大括号中的中文翻译成英文，{xxxxx}。"

  @type t :: %__MODULE__{
          type: atom(),
          content: String.t()
        }

  def new(params), do: struct!(%__MODULE__{}, params)
end
