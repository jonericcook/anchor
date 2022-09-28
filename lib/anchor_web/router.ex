defmodule AnchorWeb.Router do
  use AnchorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AnchorWeb do
    pipe_through :api
  end
end
