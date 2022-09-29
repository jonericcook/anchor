defmodule AnchorWeb.Plug.Auth do
  import Plug.Conn

  alias Anchor.Accounts
  alias Anchor.Accounts.User

  def init(options), do: options

  def call(conn, _opts) do
    with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         %User{} = user <- Accounts.find_by_username_and_password(user, pass) do
      assign(conn, :current_user, user)
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end
end
