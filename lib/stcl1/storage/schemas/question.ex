defmodule Stcl1.Storage.Schemas.Question do
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @primary_key {:chat_id, :string, []}
  schema "questions" do
    field(:text, :string)
    field(:status, :string)

    timestamps()
  end

  def changeset(question \\ %__MODULE__{}, attrs) do
    question
    |> cast(attrs, [
      :chat_id,
      :text,
      :status,
      :inserted_at,
      :updated_at
    ])
    |> unique_constraint(:chat_id, name: :questions_chat_id_index)
  end
end
