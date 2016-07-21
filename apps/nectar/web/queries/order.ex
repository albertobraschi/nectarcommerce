defmodule Nectar.Query.Order do
  use Nectar.Query, model: Nectar.Order

  @default_total Decimal.new("0")
  def shipping_total(repo, order) do
    repo.one(
      from shipment_adj in Ecto.assoc(order, :adjustments),
      where: not is_nil(shipment_adj.shipment_id),
      select: sum(shipment_adj.amount)
    ) || @default_total
  end

  def tax_total(repo, order) do
    repo.one(
      from tax_adj in Ecto.assoc(order, :adjustments),
      where: not is_nil(tax_adj.tax_id),
      select: sum(tax_adj.amount)
    ) || @default_total
  end

  def product_total(repo, order) do
    repo.one(
      from line_item in Ecto.assoc(order, :line_items),
      where: line_item.fullfilled == true,
      select: sum(line_item.total)
    ) || @default_total
  end

  def can_be_fullfilled?(repo, order) do
    repo.all(from ln in Ecto.assoc(order, :line_items), select: ln.fullfilled)
    |> Enum.any?
  end

  def cart_empty?(repo, %Nectar.Order{} = order) do
    repo.one(from ln in Ecto.assoc(order, :line_items), select: count(ln.id)) == 0
  end

  def billing_address(order),
    do: from o in Ecto.assoc(order, :order_billing_address)

  def billing_address(order),
    do: from o in Nectar.OrderBillingAddress, where: o.order_id == ^order.id

  def shipping_address(order),
    do: from o in Ecto.assoc(order, :order_shipping_address)

  def payment(order),
    do: from o in Ecto.assoc(order, :payment)

  def tax_adjustments(order),
    do: from o in Ecto.assoc(order, :adjustments), where: not(is_nil(o.tax_id))

  def shipment_units(order),
    do: from o in Ecto.assoc(order, :shipment_units)

  def shipment_adjustements(order),
    do: from o in Ecto.assoc(order, :adjustments), where: not(is_nil(o.shipment_id))

  def shipments(order),
    do: from o in Ecto.assoc(order, :shipments)

end
