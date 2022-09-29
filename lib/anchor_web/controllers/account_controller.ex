defmodule AnchorWeb.AccountController do
  use AnchorWeb, :controller

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
end
