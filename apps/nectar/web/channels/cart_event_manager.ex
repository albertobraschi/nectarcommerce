defmodule CartEventManager do
  use GenEvent
  alias Nectar.Order
  alias Nectar.Repo
  import Ecto.Query

  # based on: http://learningelixir.joekain.com/using-genevent-to-notify-a-channel/
  @name :cart_event_manager

  def child_spec, do: Supervisor.Spec.worker(GenEvent, [[name: @name]])

  def send_notification_if_out_of_stock(order) do
    GenEvent.notify(@name, {:out_of_stock, order})
  end

  def register(handler, args) do
    GenEvent.add_handler(@name, handler, args)
  end

  def register_with_manager do
    CartEventManager.register(__MODULE__, nil)
  end

  def handle_event({:out_of_stock, order}, state) do
    Enum.each(out_of_stock_carts(order), fn (%Order{id: id}) ->
      IO.puts "sending notification to cart:#{id}"
      Nectar.Endpoint.broadcast "cart:#{id}", "new_notification", %{msg: "some product in your cart are out of stock"}
    end)
    {:ok, state}
  end

  def out_of_stock_carts(order) do
    out_of_stock_variants_in_cart =
      Repo.all(from v in Order.variants_in_cart(order), where: v.bought_quantity == v.total_quantity, select: v.id)
    Repo.all(Order.with_variants_in_cart(out_of_stock_variants_in_cart))
  end


end
