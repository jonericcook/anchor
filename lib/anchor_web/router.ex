defmodule AnchorWeb.Router do
  use AnchorWeb, :router

  pipeline :signup do
    plug :accepts, ["json"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug AnchorWeb.Plug.JwtAuth
  end

  pipeline :authenticate do
    plug :accepts, ["json"]
    plug AnchorWeb.Plug.Auth
  end

  scope "/transactions", AnchorWeb do
    pipe_through :api
    post "/", TransactionController, :create
    get "/ss/quote_currency_amount/entire_dataset", TransactionController, :ss_quote_currency_amount_entire_dataset
    get "/ss/quote_currency_amount/stock_buy", TransactionController, :ss_quote_currency_amount_stock_buy
    get "/ss/quote_currency_amount/each_type", TransactionController, :ss_quote_currency_amount_each_type
    get "/ss/quote_currency_amount/each_type_quote_currency_combo", TransactionController, :ss_quote_currency_amount_each_type_quote_currency_combo
    delete "/:id", TransactionController, :delete
  end

  scope "/auth", AnchorWeb do
    pipe_through :authenticate
    get "/", AccountController, :auth
  end

  scope "/signup", AnchorWeb do
    pipe_through :signup
    post "/", AccountController, :create
  end
end
