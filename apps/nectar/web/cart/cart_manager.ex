defmodule Nectar.CartManager do
  alias Nectar.Order
  alias Nectar.Variant
  alias Nectar.LineItem
  alias Nectar.Repo

  def add_to_cart(%Nectar.Order{} = order, %{"variant_id" => variant_id, "quantity" => quantity}) do
    variant = Nectar.Query.Variant.get!(Repo, variant_id) |> Repo.preload([:product])
    do_add_to_cart(order, variant, quantity)
  end

  def add_to_cart(order_id, %{"variant_id" => variant_id, "quantity" => quantity}) do
    order = Repo.get!(Order, order_id)
    variant = Nectar.Query.Variant.get!(Repo, variant_id) |> Repo.preload([:product])
    do_add_to_cart(order, variant, quantity)
  end

  defp do_add_to_cart(%Order{} = order, %Variant{} = variant, quantity) do
    line_item = Nectar.Query.LineItem.in_order_with_variant(Repo, order, variant)
    update_result =
      case line_item do
        nil ->
          Nectar.Workflow.AddNewItemToCart.run(Repo, variant, order, quantity)
        line_item ->
          Nectar.Workflow.UpdateQuantityInCart.run(Repo, line_item, variant, quantity)
      end
    process_update(update_result)
  end

  defp process_update({:ok, update_result}),
    do: {:ok, update_result[:line_item]}

  defp process_update({:error, _name, message, _result}),
    do: {:error, message}

end
