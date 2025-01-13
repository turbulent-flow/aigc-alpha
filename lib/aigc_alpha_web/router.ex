defmodule AIGCAlphaWeb.Router do
  use AIGCAlphaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AIGCAlphaWeb do
    pipe_through :api
  end
end
