defmodule Stcl1.Storage.Schemas.Option do
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @primary_key {:name, :string, []}
  schema "options" do
    field(:value_number, :integer)
  end

  def changeset(option \\ %__MODULE__{}, attrs) do
    option
    |> cast(attrs, [
      :name,
      :value_number
    ])
    |> unique_constraint(:name, name: :users_name_index)
  end
end
