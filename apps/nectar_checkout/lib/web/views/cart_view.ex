defmodule Nectar.CartView do
  use NectarCore.Web, :view

  def cart_empty?(%Nectar.Order{line_items: []}), do: true
  def cart_empty?(%Nectar.Order{} = _order), do: false

  def render("cart.json",  %{order: order, summary: "true"}) do
    %{
      items_in_cart: Nectar.CartManager.count_items_in_cart(order)
    }
  end

  def render("cart.json", %{order: order}) do
    %{order_id: order.id}
  end
end
