defmodule DrainerBugWeb.PageController do
  use DrainerBugWeb, :controller
  require Logger

  def index(conn, _params) do
    Logger.info("sleeping")
    Process.sleep(60000)
    render(conn, "index.html")
  end
end
