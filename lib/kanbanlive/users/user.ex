defmodule Kanbanlive.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    has_many :owned_tasks, Kanbanlive.Tasks.Task , foreign_key: :relator_user_id
    has_many :assigned_tasks, Kanbanlive.Tasks.Task , foreign_key: :executor_user_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/, message: "email em formato inválido")
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password, min: 6, max: 100, message: "password must be between 6 and 100 characteres")
    |> validate_confirmation(:password, message: "Passwords does not match")
    |> unique_constraint(:email, message: "Email already in use")
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
