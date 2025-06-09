defmodule AIGCAlpha.Core.Template do
  @derive Jason.Encoder
  defstruct type: :translate_to_en,
            content: "请把大括号中的中文翻译成英文，{xxxxx}，注意直接输出翻译的内容，例如：不要把翻译的内容放在大括号内。"

  @type t :: %__MODULE__{
          type: atom(),
          content: String.t()
        }

  def new(params), do: struct!(%__MODULE__{}, params)
end
