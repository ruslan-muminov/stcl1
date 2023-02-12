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
  end

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
end
