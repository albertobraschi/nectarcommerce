defmodule Nectar.CartChannel do
  use Nectar.Web, :channel
  alias Nectar.Repo

  def join("cart:" <> cart_id, _params, socket) do
    cart_id = cart_id
    IO.inspect "joining channel"
    Task.async(fn () ->
      IO.inspect "started sleeping"
      :timer.sleep(10000)
      IO.inspect "sending new message"
      Nectar.Endpoint.broadcast_from! self(), "cart:#{cart_id}", "new_notification", %{msg: "hello world!"}
      IO.inspect "sleeping again"
      :timer.sleep(10000)
      IO.inspect "sending new message"
      Nectar.Endpoint.broadcast_from! self(), "cart:#{cart_id}", "new_notification", %{msg: "hello world!"}
    end)
    {:ok, %{}, assign(socket, :cart_id, cart_id)}
  end

  def handle_in("new_notification", params, socket) do
    broadcast! socket, "new_notification", %{
      msg: params["msg"]
    }
    {:reply, :ok, socket}
  end
end
