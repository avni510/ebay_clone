defmodule EbayClone.CloseProcess.Process do
  use GenServer

  alias EbayClone.CloseProcess.Close

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Close.execute()
    {:ok, state}
  end

  def handle_info(:close, state) do
    Close.execute()
    {:noreply, state}
  end
end
