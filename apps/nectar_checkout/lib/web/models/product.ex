defmodule Nectar.ProductForCheckout do
  use NectarCore.Web, :model
  use Arc.Ecto.Model


  schema "products" do
    field :name, :string
    field :description, :string
    field :available_on, Ecto.Date
    field :discontinue_on, Ecto.Date
    field :slug, :string

    # As this and below association same, how to handle on_delete
    has_one :master, Nectar.VariantForCheckout, on_delete: :nilify_all, foreign_key: :product_id
    has_many :variants, Nectar.VariantForCheckout, on_delete: :nilify_all, foreign_key: :product_id

    timestamps
  end

  def has_variants_excluding_master?(product) do
    Repo.one(from variant in all_variants(product), select: count(variant.id)) > 0
  end

  def variant_count(product) do
    Repo.one(from variant in all_variants_including_master(product), select: count(variant.id))
  end

  def master_variant(model) do
    from variant in all_variants_including_master(model), where: variant.is_master
  end

  def all_variants(model) do
    from variant in all_variants_including_master(model), where: not(variant.is_master)
  end

  def all_variants_including_master(model) do
    from variant in assoc(model, :variants)
  end

  # helper queries for preloading variant data.
  @master_query  from m in Nectar.VariantForCheckout, where: m.is_master
  @variant_query from m in Nectar.VariantForCheckout, where: not(m.is_master)

  def products_with_master_variant do
    from p in __MODULE__, preload: [master: ^@master_query]
  end

  def products_with_variants do
    from p in __MODULE__, preload: [master: ^@master_query, variants: ^@variant_query]
  end

  def product_with_master_variant(product_id) do
    from p in __MODULE__,
    where: p.id == ^product_id,
    preload: [master: ^@master_query]
  end

  def product_with_variants(product_id) do
    from p in __MODULE__,
    where: p.id == ^product_id,
    preload: [variants: ^@variant_query, master: ^@master_query]
  end

end
