defmodule AIGCAlpha.TCPServer.Command.Error do
  @derive Jason.Encoder
  defstruct [:reason]

  @type t :: %__MODULE__{
          reason: atom() | nil
        }
end
