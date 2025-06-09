defmodule AIGCAlpha.TCPServer.Command do
  alias AIGCAlpha.TCPServer.Vars
  alias AIGCAlpha.Core.{Input, Template, Output}
  alias AIGCAlpha.AIGCClient
  alias AIGCAlpha.AIGCClient.Error, as: AIGCClientError
  alias AIGCAlpha.TCPServer.Command.Error, as: CommandError

  @doc ~S"""
  Parses the given `line` into a command.

  ## Example

      iex> AIGCAlpha.TCPServer.Command.parse("translate to cn, {Are u okay?}\r\n")
      {:ok, {:translate_to_cn, "Are u okay?"}}

      iex> AIGCAlpha.TCPServer.Command.parse("translate to en, {你还好吗？}\r\n")
      {:ok, {:translate_to_en, "你还好吗？"}}

      iex> AIGCAlpha.TCPServer.Command.parse("explain with en, {calm}\r\n")
      {:ok, {:explain_with_en, "calm"}}

      iex> AIGCAlpha.TCPServer.Command.parse("explain with cn, {心止如水}\r\n")
      {:ok, {:explain_with_cn, "心止如水"}}

      iex> AIGCAlpha.TCPServer.Command.parse("unknown command")
      {:error, %AIGCAlpha.TCPServer.Command.Error{reason: :unknown_command}}
  """
  def parse("translate to cn" <> tails), do: {:ok, {:translate_to_cn, extract_content(tails)}}
  def parse("translate to en" <> tails), do: {:ok, {:translate_to_en, extract_content(tails)}}
  def parse("explain with en" <> tails), do: {:ok, {:explain_with_en, extract_content(tails)}}
  def parse("explain with cn" <> tails), do: {:ok, {:explain_with_cn, extract_content(tails)}}
  def parse(_), do: {:error, %CommandError{reason: :unknown_command}}

  defp extract_content(data) do
    ~r/{.*?}/
    |> Regex.run(data, capture: :first)
    |> IO.inspect(label: "matched")
    |> hd()
    |> String.replace(["{", "}"], "")
  end

  @spec run({type :: atom(), content :: String.t()}) ::
          {:ok, Output.t()} | {:error, AIGCClientError.t()}
  def run({type, content}) do
    params =
      %{
        content: content,
        template: %Template{
          type: type,
          content: Map.fetch!(Vars.template_mappings(), type)
        }
      }

    input = Input.new(params)
    AIGCClient.inquire(input)
  end
end
