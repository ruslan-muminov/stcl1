defmodule Stcl1.Repo.Migrations.CreateOptions do
  use Ecto.Migration

  def change do
    create table(:options, primary_key: false) do
      add :name, :string, primary_key: true
      add :value_number, :integer, null: false
    end
  end
end
