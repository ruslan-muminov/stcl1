defmodule Stcl1.Storage.Schemas.QuestionLog do
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @primary_key {:id, :id, autogenerate: true}
  schema "questions_log" do
    field(:question_text, :string)
    field(:answer_text, :string)
    field(:chat_id, :string)
    field(:question_dt, :utc_datetime)
    field(:answer_dt, :utc_datetime)

    timestamps()
  end

  def changeset(question \\ %__MODULE__{}, attrs) do
    question
    |> cast(attrs, [
      :question_text,
      :answer_text,
      :chat_id,
      :question_dt,
      :answer_dt
    ])
  end
end
