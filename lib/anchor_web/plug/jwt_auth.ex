defmodule AnchorWeb.Plug.JwtAuth do
  import Plug.Conn

  alias Anchor.Accounts
  alias Anchor.Accounts.User

  def init(options), do: options

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- AnchorWeb.Token.verify_and_validate(token),
         %User{} = user <-
           Accounts.find_by_username_and_password(Map.get(claims, "username"), Map.get(claims, "password")) do
      conn
      |> assign(:current_user, user)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(AnchorWeb.ErrorView)
        |> Phoenix.Controller.render(:"401")
        |> halt()
    end
  end
end
