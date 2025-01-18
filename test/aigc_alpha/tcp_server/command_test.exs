defmodule AIGCAlpha.TCPServer.CommandTest do
  use ExUnit.Case, async: true
  doctest AIGCAlpha.TCPServer.Command

  import Hammox

  alias AIGCAlpha.TCPServer.Command
  alias AIGCAlpha.Core.{Input, Template, Output}
  alias AIGCAlpha.AIGCClient.Error
  alias AIGCAlpha.AIGCClientMock

  describe "run/2" do
    test "should execute the command" do
      params = %{
        content: "你还好吗？",
        template: %Template{}
      }

      input = Input.new(params)

      expect(AIGCClientMock, :inquire, fn ^input ->
        {:ok, %Output{content: "Are u okay?"}}
      end)

      assert {:ok, %Output{content: "Are u okay?"}} = Command.run({:translate_to_en, "你还好吗？"})
    end

    test "should return an error" do
      stub(AIGCClientMock, :inquire, fn _ ->
        {:error,
         %AIGCAlpha.AIGCClient.Error{
           details: :timeout,
           status: 408
         }}
      end)

      assert {:error,
              %Error{
                status: 408,
                details: :timeout
              }} = Command.run({:translate_to_en, "你还好吗？"})
    end
  end
end
