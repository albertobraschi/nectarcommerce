defmodule Nectar.ProductController do
  use NectarCore.Web, :controller

  alias Nectar.Product
  alias Nectar.SearchProduct

  def index(conn, %{"search_product" => search_params} = _params) do
    categories = Repo.all(Nectar.Category.with_associated_products)
    products = Repo.all(SearchProduct.search(Product.products_with_master_variant, search_params))
    render(conn, "index.html", products: products, categories: categories,
      search_changeset: SearchProduct.changeset(%SearchProduct{}, search_params),
      search_action: NectarRoutes.product_path(conn, :index)
    )
  end

  def index(conn, _params) do
    products = Repo.all(Product.products_with_master_variant)

    case request_type(conn) do
      :ajax ->
        render(conn, "product_listing.json", products: products)
        _   ->
        categories = Repo.all(Nectar.Category.with_associated_products)
        render(conn, "index.html", products: products, categories: categories,
          search_changeset: SearchProduct.changeset(%SearchProduct{}),
          search_action: NectarRoutes.product_path(conn, :index)
        )
    end

  end

  def show(conn, %{"id" => id}) do
    product = Repo.one(Product.product_with_variants(id))
    render(conn, "show.html", product: product)
  end

end
