defmodule AIGCAlpha.TCPServer do
  require Logger

  alias AIGCAlpha.TCPServer.Command
  alias AIGCAlpha.TCPServer.Command.Error, as: CommandError
  alias AIGCAlpha.AIGCClient.Error, as: AIGCClientError

  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(__MODULE__.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_sctp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    with {:ok, data} <- read_line(socket),
         {:ok, command} <- Command.parse(data),
         {:ok, output} <- Command.run(command),
         normalized <- normalize(output.content),
         :ok <- write_line(socket, normalized) do
      :ok
    else
      {:error, %AIGCClientError{} = error_data} = error ->
        normalized = normalize(error_data)
        write_line(socket, normalized)
        error

      {:error, %CommandError{} = error_data} = error ->
        Logger.error(
          ~s[Calling Command.parse/1 from serve/1 failed, as the reason is #{inspect(error)}.]
        )

        normalized = normalize(error_data)
        write_line(socket, normalized)

        error

      {:error, _} = error ->
        Logger.error(
          ~s[Calling read_line/1 or write_line/2 from serve/1 failed, as the reason is #{inspect(error)}.]
        )

        normalized = normalize(error)
        write_line(socket, normalized)

        error
    end

    serve(socket)
  end

  defp normalize({:error, reason}) do
    %{error: %{details: reason}}
    |> do_normalize()
  end

  defp normalize(%AIGCClientError{} = error) do
    %{error: %{details: error}}
    |> do_normalize()
  end

  defp normalize(%CommandError{} = error) do
    %{error: %{details: error}}
    |> do_normalize()
  end

  defp normalize(content) do
    %{data: content}
    |> do_normalize()
  end

  defp do_normalize(data) do
    data
    |> Jason.encode!()
    |> Kernel.<>("\r\n")
  end

  defp read_line(socket), do: :gen_tcp.recv(socket, 0)

  defp write_line(socket, line), do: :gen_tcp.send(socket, line)
end
