defmodule Stcl1.Storage.Interfaces.Users do
  alias Stcl1.Storage.Schemas.User
  alias Stcl1.Repo

  def get(chat_id) when is_binary(chat_id) do
    Repo.get_by(User, chat_id: chat_id)
  end

  def upsert(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, [:state, :in_conversation_with_operator, :updated_at]},
      conflict_target: :chat_id,
      returning: true
    )
  end
end
