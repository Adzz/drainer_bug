defmodule DrainerBugWeb.PageController do
  use DrainerBugWeb, :controller
  require Logger

  def index(conn, _params) do
    Logger.info("sleeping for 60 seconds")
    Process.sleep(60000)
    render(conn, "index.html")
  end
end
