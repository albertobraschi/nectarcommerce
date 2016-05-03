defmodule Nectar.CartChannel do
  use Nectar.Web, :channel
  alias Nectar.Repo

  def join("cart:" <> cart_id, _params, socket) do
    cart_id = cart_id
    {:ok, %{}, assign(socket, :cart_id, cart_id)}
  end

  def handle_in("new_notification", params, socket) do
    IO.inspect "Recieved new notification"
    broadcast! socket, "new_notification", %{
      msg: params["msg"]
    }
    {:reply, :ok, socket}
  end
end
