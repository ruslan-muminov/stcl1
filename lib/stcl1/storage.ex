defmodule Stcl1.Storage do

  alias Stcl1.Storage.Question
  alias Stcl1.Storage

  # Stcl1.Storage.init()
  def init do
    nodes = [node()]

    Memento.stop
    Memento.Schema.create(nodes)
    Memento.start

    :timer.sleep(1500)

    Memento.Table.create(Storage.Option, disc_copies: nodes)
    Memento.Table.create(Storage.User, disc_copies: nodes)
    Memento.Table.create(Storage.UserExt, disc_copies: nodes)
    Memento.Table.create(Storage.Question, disc_copies: nodes)
    Memento.Table.create(Storage.QuestionLog, disc_copies: nodes)
    Memento.Table.create(Storage.DeferredQuestion, disc_copies: nodes)
    Memento.Table.create(Storage.ButtonLog, disc_copies: nodes)
    Memento.Table.create(Storage.Ads, disc_copies: nodes)
  end

  ###### Option

  # Stcl1.Storage.write_option(:qwe, 123)
  def write_option(option, value) do
    Memento.transaction! fn ->
      Memento.Query.write(%Storage.Option{option: option, value: value})
    end
  end

  # Stcl1.Storage.read_option(:qwe)
  def read_option(option) do
    option =
      Memento.transaction! fn ->
        Memento.Query.read(Storage.Option, option)
      end

    case option do
      nil -> nil
      _ -> option.value
    end
  end

  ###### User

  def write_user(chat_id, state) do
    dt = DateTime.utc_now() |> DateTime.to_unix()

    Memento.transaction! fn ->
      Memento.Query.write(%Storage.User{chat_id: chat_id, state: state, dt: dt})
    end
  end

  def read_user_state(chat_id) do
    user =
      Memento.transaction! fn ->
        Memento.Query.read(Storage.User, chat_id)
      end

    case user do
      nil -> nil
      _ -> {user.state, user.dt}
    end
  end

  def users_count do
    users =
      Memento.transaction! fn ->
        Memento.Query.all(Storage.User)
      end

    length(users)
  end

  ###### UserExt

  def reg_user_ext(chat_id) do
    dt = DateTime.utc_now() |> DateTime.to_unix()

    Memento.transaction! fn ->
      Memento.Query.write(%Storage.UserExt{chat_id: chat_id, state: :idle, dt: dt, dt_reg: dt})
    end
  end

  def write_user_state_ext(chat_id, state) do
    dt = DateTime.utc_now() |> DateTime.to_unix()

    Memento.transaction! fn ->
      dt_reg =
        case Memento.Query.read(Storage.UserExt, chat_id) do
          nil -> dt
          user_ext -> user_ext.dt_reg
        end

      Memento.Query.write(%Storage.UserExt{chat_id: chat_id, state: state, dt: dt, dt_reg: dt_reg})
    end
  end

  def read_user_ext_state(chat_id) do
    user =
      Memento.transaction! fn ->
        Memento.Query.read(Storage.UserExt, chat_id)
      end

    case user do
      nil -> nil
      _ -> {user.state, user.dt}
    end
  end

  def users_ext_count do
    users =
      Memento.transaction! fn ->
        Memento.Query.all(Storage.UserExt)
      end

    length(users)
  end

  def users_ext_all do
    Memento.transaction! fn ->
      Memento.Query.all(Storage.UserExt)
    end
  end

  def migrate_users do
    users =
      Memento.transaction! fn ->
        Memento.Query.all(Storage.User)
      end

    Memento.transaction! fn ->
      Enum.each(users, fn user ->
        Memento.Query.write(%Storage.UserExt{chat_id: user.chat_id, state: user.state, dt: user.dt, dt_reg: user.dt})
      end)
    end
  end

  def delete_user_ext(chat_id) do
    Memento.transaction! fn ->
      Memento.Query.delete(Storage.UserExt, chat_id)
    end
  end

  ###### DeferredQuestion

  # def write_deferred_question(question) do
  #   dt = DateTime.utc_now() |> DateTime.to_unix()

  #   Memento.transaction! fn ->
  #     Memento.Query.write(
  #       %Storage.DeferredQuestion{question: question, dt: dt}
  #     )
  #   end
  # end

  # def all_deferred_questions do
  #   Memento.transaction! fn ->
  #     Storage.DeferredQuestion
  #     |> Memento.Query.all()
  #     |> Enum.sort(&(&1.dt <= &2.dt))
  #   end
  # end

  # def delete_deferred_question(deferred_question) do
  #   Memento.transaction! fn ->
  #     Memento.Query.delete_record(deferred_question)
  #   end
  # end

  ###### Question

  def write_question(chat_id, {question_type, question, status}) do
    dt = DateTime.utc_now() |> DateTime.to_unix()

    Memento.transaction! fn ->
      Memento.Query.write(
        %Storage.Question{chat_id: chat_id, question_type: question_type, question: question, status: status, dt: dt}
      )
    end
  end

  def read_question(chat_id) do
    question =
      Memento.transaction! fn ->
        Memento.Query.read(Storage.Question, chat_id)
      end

    case question do
      nil -> nil
      _ -> {question.question_type, question.question, question.status, question.dt}
    end
  end

  def deferred_questions do
    Memento.transaction! fn ->
      Memento.Query.select(Question, {:==, :status, :out_of_working_hours})
    end
  end

  ###### QuestionLog

  def write_question_log(chat_id, question, question_dt, answer) do
    dt = DateTime.utc_now() |> DateTime.to_unix()
    dt_diff = if is_nil(question_dt), do: nil, else: dt - question_dt

    Memento.transaction! fn ->
      Memento.Query.write(
        %Storage.QuestionLog{question: question, answer: answer, chat_id: chat_id, dt: dt, dt_diff: dt_diff}
      )
    end
  end

  ###### ButtonLog

  def write_button_log(button_name) do
    Memento.transaction! fn ->
      count =
        case Memento.Query.read(Storage.ButtonLog, button_name) do
          nil -> 0
          button_log -> button_log.count
        end

      Memento.Query.write(
        %Storage.ButtonLog{button_name: button_name, count: count + 1}
      )
    end
  end

  ###### Ads

  def create_ads(send_dt, text) do
    id = UUID.uuid4()

    Memento.transaction! fn ->
      Memento.Query.write(
        %Storage.Ads{id: id, send_dt: send_dt, text: text, status: :wait}
      )
    end

    id
  end

  # Stcl1.Storage
  def update_ads_status(id, status) do
    Memento.transaction! fn ->
      case Memento.Query.read(Storage.Ads, id) do
        nil -> :ok
        ads ->
          Memento.Query.write(
            %Storage.Ads{id: id, status: status, send_dt: ads.send_dt, text: ads.text}
          )
      end
    end
  end

  def delete_ads(id) do
    Memento.transaction! fn ->
      Memento.Query.delete(Storage.Ads, id)
    end
  end

  def all_ads do
    Memento.transaction! fn ->
      Memento.Query.all(Storage.Ads)
    end
  end

  ###### DEBUG

  def refresh_question_log_table do
    nodes = [node()]

    Memento.Table.delete(Storage.QuestionLog)
    Memento.Table.create(Storage.QuestionLog, disc_copies: nodes)
  end

  def question_logs_debug do
    Memento.transaction! fn ->
      Memento.Query.all(Storage.QuestionLog)
    end
  end

  def refresh_users_table do
    nodes = [node()]

    Memento.Table.delete(Storage.User)
    Memento.Table.create(Storage.User, disc_copies: nodes)
  end

  def users_debug do
    Memento.transaction! fn ->
      Memento.Query.all(Storage.User)
    end
  end

  def users_ext_debug do
    Memento.transaction! fn ->
      Memento.Query.all(Storage.UserExt)
    end
  end

  def add_test_user do
    write_user(111, :finished)
  end
end
