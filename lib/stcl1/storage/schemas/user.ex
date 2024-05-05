defmodule Stcl1.Storage.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @primary_key false
  schema "users" do
    field(:chat_id, :string)
    field(:state, :string, default: "idle")
    field(:in_conversation_with_operator, :boolean, default: false)

    timestamps()
  end

  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [
      :chat_id,
      :state,
      :in_conversation_with_operator
    ])
    |> unique_constraint(:chat_id, name: :users_chat_id_index)
  end
end
