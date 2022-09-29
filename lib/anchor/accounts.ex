defmodule Anchor.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Anchor.Repo

  alias Anchor.Accounts.User

  def find_by_username_and_password(username, password) do
    Repo.one(User, username: username, password: password)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
