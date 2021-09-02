defmodule Kanbanlive.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tasks" do
    field :description, :string
    field :title, :string
    field :status, :string
    belongs_to :owner, Kanbanlive.Users.User, foreign_key: :relator_user_id
    belongs_to :asignee, Kanbanlive.Users.User, foreign_key: :executor_user_id
    timestamps()
  end

  @doc false
  def changeset(task, attrs \\ %{}) do
    task
    |> cast(attrs, [:title, :description, :status, :executor_user_id])
    |> validate_required([:title, :description, :status])
    |> unique_constraint(:title, message: "Task already created")
  end
end
