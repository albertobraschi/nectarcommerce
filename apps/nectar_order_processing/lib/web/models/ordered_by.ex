defmodule Nectar.OrderedBy do
  use NectarCore.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string

    has_many :orders, Nectar.ProcessedOrder, foreign_key: :user_id

    timestamps
  end

end
