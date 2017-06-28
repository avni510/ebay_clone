defmodule EbayClone.AwardProcess.Process do
  use GenServer

  alias EbayClone.AwardProcess.Award

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Award.execute()
    {:ok, state}
  end

  def handle_info(:award, state) do
    Award.execute()
    {:noreply, state}
  end
end
