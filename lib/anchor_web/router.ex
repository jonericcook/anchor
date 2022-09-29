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
    get "/transactions/ss/quote_currency_amount/entire_dataset", TransactionController, :ss_quote_currency_amount_entire_dataset
    get "/transactions/ss/quote_currency_amount/stock_buy", TransactionController, :ss_quote_currency_amount_stock_buy
    get "/transactions/ss/quote_currency_amount/each_type", TransactionController, :ss_quote_currency_amount_each_type
    get "/transactions/ss/quote_currency_amount/each_type_quote_currency_combo", TransactionController, :ss_quote_currency_amount_each_type_quote_currency_combo
    delete "/transactions/:id", TransactionController, :delete
  end

  scope "/auth", AnchorWeb do
    pipe_through :authenticate
    get "/", AccountController, :auth
  end
end
