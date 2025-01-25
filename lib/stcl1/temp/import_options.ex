defmodule Stcl1.Temp.ImportOptions do
  alias Stcl1.Storage.Interfaces.Options

  def run do
    last_update_id = Stcl1.Storage.read_option(:last_update_id)
    Options.upsert(%{name: "last_update_id", value_number: last_update_id})
  end
end
