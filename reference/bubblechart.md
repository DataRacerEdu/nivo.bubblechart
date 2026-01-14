# Create an Interactive Bubble Chart

Creates an interactive circle packing (bubble chart) visualization using
the Nivo library. This function produces a hierarchical bubble chart
that supports click and hover interactions in Shiny applications. Bubble
size is determined by the `value` field in your data, and colors are
fully customizable.

## Usage

``` r
bubblechart(
  element_id,
  main_color,
  label_color,
  on_hover_title_color,
  data = NULL,
  width = NULL,
  isInteractive = TRUE,
  height = "400px",
  activeColor = "transparent",
  borderWidth = 3
)
```

## Arguments

- element_id:

  Character string specifying the Shiny input ID for click events. Click
  events will be accessible in Shiny as `input$<element_id>_clicked`.
  For example, if `element_id = "my_chart"`, click events are available
  at `input$my_chart_clicked`.

- main_color:

  Character string specifying the default color for bubbles (hex color
  code, e.g., "#ff5f56" for red, "#3498db" for blue). This color is used
  as the base color for the chart border and as a fallback.

- label_color:

  Character string specifying the default label text color (hex color
  code). Use high-contrast colors for better readability (e.g.,
  "#ffffff" for white text on dark bubbles, "#000000" for black text on
  light bubbles).

- on_hover_title_color:

  Character string specifying the label color when hovering over a
  bubble (hex color code). This color is applied to the label text when
  the user hovers their mouse over a bubble, providing visual feedback.

- data:

  A nested list representing hierarchical data. Must have a "name" field
  at the root and a "children" field containing child nodes. Each child
  should have:

  - `name`: Display name for the bubble (character)

  - `value`: Numeric value determining bubble size (must be positive)

  - `color`: Hex color code for the bubble fill (character, e.g.,
    "#3498db")

  - `labelColor`: Hex color code for the label text (character, e.g.,
    "#ffffff")

  Use
  [`prepare_bubble_data`](https://dataraceredu.github.io/nivo.bubblechart/reference/prepare_bubble_data.md)
  to convert data frames to this format.

- width:

  The width of the widget. Can be a valid CSS unit (e.g., "100 percent",
  "400px", "50vw") or NULL for automatic sizing. NULL is recommended for
  responsive layouts.

- isInteractive:

  Logical. If TRUE (default), enables click and hover interactions. Set
  to FALSE for static charts in reports or presentations where
  interactivity is not needed.

- height:

  The height of the widget. Can be a valid CSS unit (e.g., "400px",
  "600px", "50vh") or NULL. Default is "400px". Adjust based on your
  layout needs and the amount of data being displayed.

- activeColor:

  Character string specifying the color of selected/active bubbles (hex
  color code). When a user clicks a bubble, it changes to this color.
  Default is "transparent", which makes the selected bubble see-through.

- borderWidth:

  Numeric value specifying the border width of bubbles in pixels.
  Default is 3. Use larger values (e.g., 5) for prominent borders,
  smaller values (e.g., 1) for subtle borders, or 0 for no borders.

## Value

An htmlwidget object of class `c("bubblechart", "htmlwidget")` that can
be:

- Rendered directly in R console or RStudio Viewer

- Included in R Markdown documents

- Used in Shiny applications with
  [`bubblechartOutput`](https://dataraceredu.github.io/nivo.bubblechart/reference/bubblechart-shiny.md)
  and
  [`renderBubblechart`](https://dataraceredu.github.io/nivo.bubblechart/reference/bubblechart-shiny.md)

- Saved to HTML with
  [`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)

## Details

The bubble chart (circle packing diagram) is a powerful way to visualize
hierarchical data where the size of each circle represents a
quantitative value. This implementation uses the Nivo visualization
library to create responsive, interactive charts that work seamlessly in
both static R documents and dynamic Shiny applications.

When used in Shiny, the chart generates click events that can be
captured via `input$<element_id>_clicked`, where `<element_id>` is the
ID you specify. Clicking a bubble returns its name, and clicking it
again returns `"DESELECT_EVENT"`.

## See also

[`prepare_bubble_data`](https://dataraceredu.github.io/nivo.bubblechart/reference/prepare_bubble_data.md)
for converting data frames to the required format,
[`bubblechartOutput`](https://dataraceredu.github.io/nivo.bubblechart/reference/bubblechart-shiny.md)
and
[`renderBubblechart`](https://dataraceredu.github.io/nivo.bubblechart/reference/bubblechart-shiny.md)
for Shiny integration.

## Examples

``` r
if (interactive()) {
library(nivo.bubblechart)

# Example 1: Basic bubble chart with manual data
sample_data <- list(
  name = "root",
  children = list(
    list(name = "Category A", color = "#ff5f56", labelColor = "#ffffff", value = 100),
    list(name = "Category B", color = "#ffbd2e", labelColor = "#ffffff", value = 200),
    list(name = "Category C", color = "#27c93f", labelColor = "#ffffff", value = 150)
  )
)

bubblechart(
  element_id = "my_chart",
  main_color = "#ff5f56",
  label_color = "#ffffff",
  on_hover_title_color = "#000000",
  data = sample_data,
  height = "500px"
)

# Example 2: Using prepare_bubble_data for data frame conversion
df <- data.frame(
  product = c("Laptop", "Phone", "Tablet"),
  sales = c(45000, 38000, 22000),
  category_color = c("#3498db", "#e74c3c", "#f39c12"),
  text_color = rep("#ffffff", 3)
)

chart_data <- prepare_bubble_data(
  df,
  name_col = "product",
  value_col = "sales",
  color_col = "category_color",
  label_color_col = "text_color"
)

bubblechart(
  element_id = "sales_chart",
  main_color = "#3498db",
  label_color = "#ffffff",
  on_hover_title_color = "#2c3e50",
  data = chart_data,
  height = "600px"
)

# Example 3: Customized appearance
bubblechart(
  element_id = "custom_chart",
  main_color = "#2c3e50",
  label_color = "#ecf0f1",
  on_hover_title_color = "#f39c12",
  activeColor = "#e74c3c",  # Red when selected
  borderWidth = 5,          # Thicker borders
  data = sample_data,
  isInteractive = TRUE
)
}
```
