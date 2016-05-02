defmodule Nectar.CartChannel do
  use Nectar.Web, :channel
  alias Nectar.Repo

  def join("cart", _params, socket) do
    user = Repo.get User, socket.assigns.user_id
    cart_id = Nectar.Order.current_order(user)
    {:ok, %{}, assign(socket, :cart_id, cart_id)}
  end

  def handle_in(event, params, socket) do
    user = Repo.get User, socket.assigns.user_id
    handle_in(event, params, user, socket)
  end

  def handle_in("new_notification", params, user, socket) do
    broadcast! socket, "new_notification", %{
      msg: params["msg"]
    }
    {:reply, :ok, socket}
  end
end
