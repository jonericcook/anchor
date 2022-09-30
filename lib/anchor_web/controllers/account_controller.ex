defmodule AnchorWeb.AccountController do
  use AnchorWeb, :controller

  alias Anchor.Accounts
  alias Anchor.Accounts.User

  action_fallback AnchorWeb.FallbackController

  def auth(conn, _opts) do
    user = Map.get(conn.assigns, :current_user)

    token =
      AnchorWeb.Token.generate_and_sign!(%{
        "username" => user.username,
        "password" => user.password
      })

    json(conn, %{token: token})
  end

  def create(conn, %{"username" => _username, "password" => _password} = user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> json(%{user: %{id: user.id, username: user.username, password: user.password}})
    end
  end
end
