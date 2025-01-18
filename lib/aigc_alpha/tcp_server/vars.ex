defmodule AIGCAlpha.TCPServer.Vars do
  def template_mappings,
    do: %{
      translate_to_en: "请把大括号中的中文翻译成英文，{xxxxx}。",
      translate_to_cn: "请把大括号中的英文翻译成中文，{xxxxx}。",
      explain_with_en: "请参照 english to english cambridge dictionary，解释大括号中的词语，并给出音标以及示例，{xxxxx}。",
      explain_with_cn: "请参照汉语词典，解释大括号中的词语，并给出读音以及示例，{xxxxx}。"
    }
end
