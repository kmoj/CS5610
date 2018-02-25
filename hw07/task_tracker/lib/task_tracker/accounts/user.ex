defmodule TaskTracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Accounts.User
  alias TaskTracker.Account.Manage


  schema "users" do
    field :email, :string
    field :manager, :boolean, default: false
    field :name, :string

    has_many :manager_manages, Manage, foreign_key: :manager_id
    has_many :managee_manages_by, Manage, foreign_key: :managee_id
    has_many :managers, through: [:managee_manages_by, :manager]
    has_many :managees, through: [:manager_manages, :managee]

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :manager])
    |> validate_required([:name, :email, :manager])
  end
end
