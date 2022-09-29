defmodule AnchorWeb.Router do
  use AnchorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AnchorWeb do
    pipe_through :api
    post "/transactions", TransactionController, :create
    get "/transactions/ss/quote_currency_amount", TransactionController, :ss_quote_currency_amount
    delete "/transactions/:id", TransactionController, :delete
  end
end
