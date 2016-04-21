defmodule Nectar.ProcessedOrder do
  use NectarCore.Web, :model

  alias __MODULE__, as: Order

  #TODO: remove irrelavent fields & methods not related to manipulating completed orders

  schema "orders" do
    # concrete fields
    field :state, :string
    field :slug, :string
    field :total, :decimal, default: Decimal.new("0")
    field :confirmation_status, :boolean, default: true
    field :product_total, :decimal, default: Decimal.new("0")

    # relationships
    has_many :line_items, Nectar.LineItem, foreign_key: :order_id
    has_many :adjustments, Nectar.Adjustment, foreign_key: :order_id
    has_one  :shipping, Nectar.Shipping, foreign_key: :order_id
    has_many :variants, through: [:line_items, :variant], foreign_key: :order_id
    has_one  :payment, Nectar.Payment, foreign_key: :order_id

    has_one  :order_billing_address, Nectar.OrderBillingAddress, foreign_key: :order_id
    has_one  :billing_address, through: [:order_billing_address, :address]

    has_one  :order_shipping_address, Nectar.OrderShippingAddress, foreign_key: :order_id
    has_one  :shipping_address, through: [:order_shipping_address, :address]

    belongs_to :user, Nectar.User

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(slug confirmation_status same_as_billing)

  @states ~w(cart address shipping tax payment confirmation)

  def states do
    @states
  end

  def confirmed?(%Order{}), do: true

  # cancelling all line items will automatically cancel the order.
  def cancel_order(model) do
    Repo.transaction(fn ->
      model
      |> Repo.preload([:line_items])
      |> Map.get(:line_items)
      |> Enum.each(&(Nectar.LineItem.cancel_fullfillment(&1)))
    end)
  end

  def settle_adjustments_and_product_payments(model) do
    adjustment_total = shipping_total(model) |> Decimal.add(tax_total(model))
    product_total = product_total(model)
    total = Decimal.add(adjustment_total, product_total)
    model
    |> cast(%{total: total, product_total: product_total,
              confirmation_status: can_be_fullfilled?(model)},
            ~w(confirmation_status total product_total), ~w())
    |> Repo.update!
  end

  # if none of the line items can be fullfilled cancel the order
  def can_be_fullfilled?(%Order{} = order) do
    Repo.all(from ln in assoc(order, :line_items), select: ln.fullfilled)
    |> Enum.any?
  end

  def current_order(user) do
    Repo.one(from order in all_abandoned_orders_for(user),
             order_by: [desc: order.updated_at],
             limit: 1)
  end

  def all_abandoned_orders_for(user) do
    (from order in all_orders_for(user),
     where: not(order.state == "confirmation"))
  end

  def all_orders_for(user) do
    (from o in Nectar.Order, where: o.user_id == ^user.id)
  end

  def shipping_total(model) do
    Repo.one(
      from shipping_adj in assoc(model, :adjustments),
      where: not is_nil(shipping_adj.shipping_id),
      select: sum(shipping_adj.amount)
    ) || Decimal.new("0")
  end

  def tax_total(model) do
    Repo.one(
      from tax_adj in assoc(model, :adjustments),
      where: not is_nil(tax_adj.tax_id),
      select: sum(tax_adj.amount)
    ) || Decimal.new("0")
  end

  def product_total(model) do
    Repo.one(
      from line_item in assoc(model, :line_items),
      where: line_item.fullfilled == true,
      select: sum(line_item.total)
    ) || Decimal.new("0")
  end

end
