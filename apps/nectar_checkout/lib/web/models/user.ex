defmodule Nectar.UserForCheckout do

  use NectarCore.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string

    has_many :orders, Nectar.Order, foreign_key: :user_id
    has_many :user_addresses, Nectar.UserAddress, foreign_key: :user_id
    has_many :addresses, through: [:user_addresses, :address]

    timestamps
  end

end
