defmodule SmartRecipeCalculatorWeb.Router do
  use SmartRecipeCalculatorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SmartRecipeCalculatorWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SmartRecipeCalculatorWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/recipes", RecipeLive.Index, :index
    live "/recipes/new", RecipeLive.Index, :new
    live "/recipes/:id/edit", RecipeLive.Index, :edit

    live "/recipes/:id", RecipeLive.Show, :show
    live "/recipes/:id/show/edit", RecipeLive.Show, :edit
    live "/recipes/:id/ingredients/new", RecipeLive.Show, :new_ingredient

    live "/ingredients", IngredientLive.Index, :index
    live "/ingredients/new", IngredientLive.Index, :new
    live "/ingredients/:id/edit", IngredientLive.Index, :edit
    live "/ingredients/:id", IngredientLive.Show, :show
    live "/ingredients/:id/show/edit", IngredientLive.Show, :edit

    live "/ingredient_details", IngredientDetailLive.Index, :index
    live "/ingredient_details/new", IngredientDetailLive.Index, :new
    live "/ingredient_details/:id/edit", IngredientDetailLive.Index, :edit
    live "/ingredient_details/:id", IngredientDetailLive.Show, :show
    live "/ingredient_details/:id/show/edit", IngredientDetailLive.Show, :edit

    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit
    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", SmartRecipeCalculatorWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:smart_recipe_calculator, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SmartRecipeCalculatorWeb.Telemetry
    end
  end
end
