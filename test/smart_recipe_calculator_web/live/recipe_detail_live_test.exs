defmodule SmartRecipeCalculatorWeb.RecipeDetailLiveTest do
  use SmartRecipeCalculatorWeb.ConnCase

  import Phoenix.LiveViewTest
  import SmartRecipeCalculator.RecipesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_recipe_detail(_) do
    recipe_detail = recipe_detail_fixture()
    %{recipe_detail: recipe_detail}
  end

  describe "Index" do
    setup [:create_recipe_detail]

    test "lists all recipe_details", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/recipe_details")

      assert html =~ "Listing Recipe details"
    end

    test "saves new recipe_detail", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/recipe_details")

      assert index_live |> element("a", "New Recipe detail") |> render_click() =~
               "New Recipe detail"

      assert_patch(index_live, ~p"/recipe_details/new")

      assert index_live
             |> form("#recipe_detail-form", recipe_detail: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#recipe_detail-form", recipe_detail: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/recipe_details")

      html = render(index_live)
      assert html =~ "Recipe detail created successfully"
    end

    test "updates recipe_detail in listing", %{conn: conn, recipe_detail: recipe_detail} do
      {:ok, index_live, _html} = live(conn, ~p"/recipe_details")

      assert index_live |> element("#recipe_details-#{recipe_detail.id} a", "Edit") |> render_click() =~
               "Edit Recipe detail"

      assert_patch(index_live, ~p"/recipe_details/#{recipe_detail}/edit")

      assert index_live
             |> form("#recipe_detail-form", recipe_detail: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#recipe_detail-form", recipe_detail: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/recipe_details")

      html = render(index_live)
      assert html =~ "Recipe detail updated successfully"
    end

    test "deletes recipe_detail in listing", %{conn: conn, recipe_detail: recipe_detail} do
      {:ok, index_live, _html} = live(conn, ~p"/recipe_details")

      assert index_live |> element("#recipe_details-#{recipe_detail.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#recipe_details-#{recipe_detail.id}")
    end
  end

  describe "Show" do
    setup [:create_recipe_detail]

    test "displays recipe_detail", %{conn: conn, recipe_detail: recipe_detail} do
      {:ok, _show_live, html} = live(conn, ~p"/recipe_details/#{recipe_detail}")

      assert html =~ "Show Recipe detail"
    end

    test "updates recipe_detail within modal", %{conn: conn, recipe_detail: recipe_detail} do
      {:ok, show_live, _html} = live(conn, ~p"/recipe_details/#{recipe_detail}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Recipe detail"

      assert_patch(show_live, ~p"/recipe_details/#{recipe_detail}/show/edit")

      assert show_live
             |> form("#recipe_detail-form", recipe_detail: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#recipe_detail-form", recipe_detail: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/recipe_details/#{recipe_detail}")

      html = render(show_live)
      assert html =~ "Recipe detail updated successfully"
    end
  end
end
