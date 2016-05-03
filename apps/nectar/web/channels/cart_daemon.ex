defmodule CartDaemon do
  use GenServer

  defmodule State, do: defstruct cart_id: nil, counter: 0

  def get(cart_id) do
    daemon_name = String.to_atom "cart_daemon_#{cart_id}"
    case GenServer.whereis daemon_name do
      nil -> start(cart_id, daemon_name)
      server -> {:ok, server}
    end
  end

  def start(cart_id, name) do
    state = %State{cart_id: cart_id}
    GenServer.start(__MODULE__, state, name: name)
  end

  def handle_cast({:monitor}, state) do
    # process to check if out of stock
    Process.send_after(self(), {:check_out_of_stock}, 50)
    # call self every 20000ms
    Process.send_after(self(), {:monitor}, 4000)
    {:noreply, %State{state|counter: state.counter + 1}}
  end

  def handle_info({:check_out_of_stock}, state) do
    Nectar.Endpoint.broadcast "cart:#{state.cart_id}", "new_notification", %{msg: "out of stock notification #{state.counter}"}
    {:noreply, state}
  end

  def handle_info({:monitor}, state) do
    GenServer.cast(self(), {:monitor})
    {:noreply, state}
  end

end
