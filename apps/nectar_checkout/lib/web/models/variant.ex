defmodule Nectar.VariantForCheckout do
  use NectarCore.Web, :model
  use Arc.Ecto.Model

  alias __MODULE__, as: Variant

  schema "variants" do
    field :is_master, :boolean, default: false
    field :sku, :string
    field :weight, :decimal
    field :height, :decimal
    field :width, :decimal
    field :depth, :decimal
    field :discontinue_on, Ecto.Date
    field :cost_price, :decimal
    field :cost_currency, :string
    field :image, Nectar.VariantForCheckoutImage.Type

    field :total_quantity, :integer, default: 0

    field :bought_quantity, :integer, default: 0
    field :buy_count, :integer, virtual: true
    field :restock_count, :integer, virtual: true

    belongs_to :product, Nectar.ProductForCheckout

    has_many :line_items, Nectar.LineItem, foreign_key: :variant_id

    has_many :variant_option_values, Nectar.VariantOptionValue, on_delete: :delete_all, on_replace: :delete, foreign_key: :variant_id
    has_many :option_values, through: [:variant_option_values, :option_value]
    timestamps
  end

  def buy_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(buy_count), ~w())
    |> validate_number(:buy_count, greater_than: 0)
    |> increment_bought_quantity
  end

  def restocking_changeset(model, params) do
    model
    |> cast(params, ~w(restock_count), ~w())
    |> validate_number(:restock_count, greater_than: 0)
    |> decrement_bought_quantity
  end

  defp increment_bought_quantity(model) do
    quantity_to_add = model.changes[:buy_count]
    if quantity_to_add do
      put_change(model, :bought_quantity, (model.model.bought_quantity || 0) + quantity_to_add)
    else
      model
    end
  end

  defp decrement_bought_quantity(model) do
    quantity_to_subtract = model.changes[:restock_count]
    if quantity_to_subtract do
      put_change(model, :bought_quantity, (model.model.bought_quantity || 0) - quantity_to_subtract)
    else
      model
    end
  end

  def available_quantity(%Variant{total_quantity: total_quantity, bought_quantity: bought_quantity}) when is_nil(bought_quantity) do
    total_quantity
  end

  def available_quantity(%Variant{total_quantity: total_quantity, bought_quantity: bought_quantity}) do
    total_quantity - bought_quantity
  end

  def display_name(variant) do
    product = variant |> Repo.preload([:product]) |> Map.get(:product)
    "#{product.name}(#{variant.sku})"
  end

end
