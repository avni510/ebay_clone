defmodule EbayClone.CloseProcess.Process do
  use GenServer

  alias EbayClone.CloseProcess.Close

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    handle_info(:close, state)
    {:ok, state}
  end

  def handle_info(:close, state) do
    Close.execute()
    {:noreply, state}
    twenty_four_hours = 24 * 60 * 60 * 1000
    Process.send_after(self(), :close, twenty_four_hours)
  end
end
