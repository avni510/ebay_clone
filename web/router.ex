defmodule EbayClone.Router do
  use EbayClone.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :hidden do
    plug EbayClone.Plugs.Hide
  end

  pipeline :authentication do
    plug EbayClone.Plugs.Authenticate
  end

  scope "/", EbayClone do
    pipe_through :browser

    get "/", HomepageController, :get_homepage

    get "/login", SessionController, :new

    post "/login", SessionController, :create
  end

  scope "/", EbayClone do
    pipe_through [:browser, :hidden]

    resources "/registrations", RegistrationController, only: [:new, :create]
  end

  scope "/", EbayClone do
    pipe_through [:browser, :authentication]

    resources "/items", ItemController

    get "/myitems", ItemController, :user_items_index

    delete "/logout", SessionController, :delete

    post "/items/:id/bids", BidController, :create_item_bid

    get "/items/:id/bids", BidController, :show_bids_per_item

    get "/users/:id/bids", BidController, :show_bids_per_user
  end
end
