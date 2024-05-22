defmodule Stcl1.Storage.Interfaces.Users do
  import Ecto.Query, except: [update: 2]

  alias Stcl1.Storage.Schemas.User
  alias Stcl1.Repo

  def get(chat_id) when is_binary(chat_id) do
    Repo.get(User, chat_id)
  end

  def upsert(attrs, replace_fields \\ [:state, :updated_at]) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, replace_fields},
      conflict_target: :chat_id,
      returning: true
    )
  end

  def update(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_state(user, state) do
    update(user, %{state: state})
  end

  def count do
    Repo.aggregate(User, :count, :chat_id)
  end

  def select_from_date(naive_datetime, order_direction \\ [asc: :inserted_at]) do
    User
    |> where([u], u.inserted_at > ^naive_datetime)
    |> order_by(^order_direction)
    |> Repo.all()
  end

  def select_between_dates(naive_datetime_from, naive_datetime_to, order_direction \\ [asc: :inserted_at]) do
    User
    |> where([u], u.inserted_at > ^naive_datetime_from and u.inserted_at < ^naive_datetime_to)
    |> order_by(^order_direction)
    |> Repo.all()
  end

  def select_finished do
    dt = NaiveDateTime.add(NaiveDateTime.utc_now(), - 10 * 60)

    User
    |> where([u], u.updated_at < ^dt and u.state == "idle" and not u.in_conversation_with_operator)
    |> Repo.all()
  end
end
