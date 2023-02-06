defmodule Stcl1Web.PageController do
  use Stcl1Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
