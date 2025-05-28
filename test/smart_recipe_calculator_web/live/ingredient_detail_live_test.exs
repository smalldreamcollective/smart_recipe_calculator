defmodule SmartRecipeCalculatorWeb.IngredientDetailLiveTest do
  use SmartRecipeCalculatorWeb.ConnCase

  import Phoenix.LiveViewTest
  import SmartRecipeCalculator.IngredientsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_ingredient_detail(_) do
    ingredient_detail = ingredient_detail_fixture()
    %{ingredient_detail: ingredient_detail}
  end

  describe "Index" do
    setup [:create_ingredient_detail]

    test "lists all ingredient_details", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/ingredient_details")

      assert html =~ "Listing Ingredient details"
    end

    test "saves new ingredient_detail", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/ingredient_details")

      assert index_live |> element("a", "New Ingredient detail") |> render_click() =~
               "New Ingredient detail"

      assert_patch(index_live, ~p"/ingredient_details/new")

      assert index_live
             |> form("#ingredient_detail-form", ingredient_detail: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#ingredient_detail-form", ingredient_detail: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/ingredient_details")

      html = render(index_live)
      assert html =~ "Ingredient detail created successfully"
    end

    test "updates ingredient_detail in listing", %{conn: conn, ingredient_detail: ingredient_detail} do
      {:ok, index_live, _html} = live(conn, ~p"/ingredient_details")

      assert index_live |> element("#ingredient_details-#{ingredient_detail.id} a", "Edit") |> render_click() =~
               "Edit Ingredient detail"

      assert_patch(index_live, ~p"/ingredient_details/#{ingredient_detail}/edit")

      assert index_live
             |> form("#ingredient_detail-form", ingredient_detail: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#ingredient_detail-form", ingredient_detail: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/ingredient_details")

      html = render(index_live)
      assert html =~ "Ingredient detail updated successfully"
    end

    test "deletes ingredient_detail in listing", %{conn: conn, ingredient_detail: ingredient_detail} do
      {:ok, index_live, _html} = live(conn, ~p"/ingredient_details")

      assert index_live |> element("#ingredient_details-#{ingredient_detail.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#ingredient_details-#{ingredient_detail.id}")
    end
  end

  describe "Show" do
    setup [:create_ingredient_detail]

    test "displays ingredient_detail", %{conn: conn, ingredient_detail: ingredient_detail} do
      {:ok, _show_live, html} = live(conn, ~p"/ingredient_details/#{ingredient_detail}")

      assert html =~ "Show Ingredient detail"
    end

    test "updates ingredient_detail within modal", %{conn: conn, ingredient_detail: ingredient_detail} do
      {:ok, show_live, _html} = live(conn, ~p"/ingredient_details/#{ingredient_detail}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Ingredient detail"

      assert_patch(show_live, ~p"/ingredient_details/#{ingredient_detail}/show/edit")

      assert show_live
             |> form("#ingredient_detail-form", ingredient_detail: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#ingredient_detail-form", ingredient_detail: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/ingredient_details/#{ingredient_detail}")

      html = render(show_live)
      assert html =~ "Ingredient detail updated successfully"
    end
  end
end
