defmodule Kanbanlive.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string
      add :status, :string
      add :relator_user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :executor_user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:tasks, [:title])
    create index(:tasks, [:relator_user_id])
    create index(:tasks, [:executor_user_id])
  end
end
