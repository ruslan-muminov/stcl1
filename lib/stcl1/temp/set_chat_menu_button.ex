defmodule Stcl1.Temp.SetChatMenuButton do
  alias Stcl1.ChatMenuButton
  alias Stcl1.Repo
  alias Stcl1.Storage.Schemas.User

  def run do
    User
    |> Repo.all
    |> Enum.each(fn user ->
      ChatMenuButton.set(user.chat_id)
    end)
  end
end
