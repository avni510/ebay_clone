defmodule EbayClone.Router do
  use EbayClone.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EbayClone do
    pipe_through :browser

    resources "/registrations", RegistrationController, only: [:new, :create]

    resources "/items", ItemController

    get "/", SessionController, :new

    post "/", SessionController, :create

    delete "/logout", SessionController, :delete
  end
end
