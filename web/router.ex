defmodule EbayClone.Router do
  use EbayClone.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authentication do
    plug EbayClone.Plug.Authenticate
  end

  scope "/", EbayClone do
    pipe_through :browser

    get "/", SessionController, :new

    post "/", SessionController, :create

    resources "/registrations", RegistrationController, only: [:new, :create]

    delete "/logout", SessionController, :delete
  end

  scope "/", EbayClone do

    pipe_through [:browser, :authentication]

    resources "/items", ItemController

    get "/myitems", ItemController, :user_items_index
  end
end
