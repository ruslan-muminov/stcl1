defmodule Stcl1.Storage do

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
    Memento.Table.create(Storage.Question, disc_copies: nodes)
    Memento.Table.create(Storage.QuestionLog, disc_copies: nodes)
    Memento.Table.create(Storage.ButtonLog, disc_copies: nodes)
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
      _ -> {question.question_type, question.question, question.status}
    end
  end

  ###### QuestionLog

  def write_question_log(chat_id, question) do
    dt = DateTime.utc_now() |> DateTime.to_unix()

    Memento.transaction! fn ->
      Memento.Query.write(
        %Storage.QuestionLog{question: question, chat_id: chat_id, dt: dt}
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

  ###### DEBUG

  def refresh_users_table do
    Memento.Table.delete(Storage.User)
    Memento.Table.create(Storage.User, disc_copies: nodes)
  end

  def users_debug do
    Memento.transaction! fn ->
      Memento.Query.all(Storage.User)
    end
  end

  def add_test_user do
    write_user(111, :finished)
  end
end
