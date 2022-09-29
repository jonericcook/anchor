defmodule AnchorWeb.Router do
  use AnchorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug AnchorWeb.Plug.JwtAuth
  end

  pipeline :authenticate do
    plug :accepts, ["json"]
    plug AnchorWeb.Plug.Auth
  end

  scope "/", AnchorWeb do
    pipe_through :api
    post "/transactions", TransactionController, :create
    get "/transactions/ss/quote_currency_amount", TransactionController, :ss_quote_currency_amount
    delete "/transactions/:id", TransactionController, :delete
  end

  scope "/auth", AnchorWeb do
    pipe_through :authenticate
    get "/", AccountController, :auth
  end
end
