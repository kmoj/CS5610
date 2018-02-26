defmodule TaskTracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Accounts.User


  schema "users" do
    field :email, :string
    field :manage_level, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :manage_level])
    |> validate_required([:name, :email, :manage_level])
  end
end
