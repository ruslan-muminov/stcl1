defmodule Stcl1.Temp.ImportUsers do
  alias Stcl1.Storage.Interfaces.Users

  def run do
    users = Stcl1.Storage.users_ext_all()

    Enum.each(users, fn user ->
      attrs = %{
        chat_id: inspect(user.chat_id),
        state: to_string(user.state),
        in_conversation_with_operator: false,
        inserted_at: user.dt_reg |> DateTime.from_unix!() |> DateTime.to_naive()
      }

      Users.upsert(attrs, [:state, :in_conversation_with_operator, :inserted_at, :updated_at])
    end)
  end
end
