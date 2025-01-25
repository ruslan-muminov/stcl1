defmodule Stcl1.Storage.Interfaces.Options do
  alias Stcl1.Repo
  alias Stcl1.Storage.Schemas.Option

  def get(name) when is_binary(name) do
    Repo.get(Option, name)
  end

  def upsert(attrs) do
    %Option{}
    |> Option.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, [:value_number]},
      conflict_target: :name,
      returning: true
    )
  end
end
