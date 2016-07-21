defmodule Nectar.Command.Order do
  use Nectar.Command, model: Nectar.Order

  def create_empty_cart_for_guest!(repo),
    do: Nectar.Order.cart_changeset(%Nectar.Order{}, %{}) |> repo.insert!

  def create_empty_cart_for_user!(repo, user_id),
    do: Nectar.Order.user_cart_changeset(%Nectar.Order{}, %{user_id: user_id}) |> repo.insert!

  def update_with_order_settlement(repo, order, params) do
    Nectar.Order.settlement_changeset(order, params)
    |> repo.update
  end


end
