# Prepare Data Frame for Bubble Chart

Converts a data frame into the hierarchical list structure required by
[`bubblechart`](https://dataraceredu.github.io/nivo.bubblechart/reference/bubblechart.md).
This helper function bridges the gap between tabular data (data frames)
and the nested format expected by the Nivo circle packing visualization,
making it easy to create bubble charts from your existing data.

## Usage

``` r
prepare_bubble_data(
  df,
  name_col = "name",
  value_col = "value",
  color_col = "color",
  label_color_col = "labelColor",
  root_name = "root",
  default_color = "#ff5f56",
  default_label_color = "#ffffff"
)
```

## Arguments

- df:

  A data frame containing your data. Must have at least two columns: one
  for names and one for values. Color columns are optional.

- name_col:

  Character string specifying the column name for bubble names. This
  will be the text displayed on each bubble. Default is "name".

- value_col:

  Character string specifying the column name for bubble values. These
  values determine the size of each bubble - larger values create larger
  bubbles. Values must be positive numbers. Default is "value".

- color_col:

  Character string specifying the column name for bubble colors, or
  NULL. If provided, this column should contain hex color codes (e.g.,
  "#3498db"). If NULL or if the column doesn't exist, `default_color` is
  used. Default is "color".

- label_color_col:

  Character string specifying the column name for label colors, or NULL.
  If provided, this column should contain hex color codes for the text
  labels. If NULL or if the column doesn't exist, `default_label_color`
  is used. Default is "labelColor".

- root_name:

  Character string for the root node name. This is used internally by
  the visualization and typically doesn't need to be changed. Default is
  "root".

- default_color:

  Character string for default bubble color (hex code). Used when
  `color_col` is NULL or when a row has a missing color value. Default
  is "#ff5f56" (a warm red).

- default_label_color:

  Character string for default label text color (hex code). Used when
  `label_color_col` is NULL or when a row has a missing label color.
  Default is "#ffffff" (white). Use "#000000" for black text on light
  backgrounds.

## Value

A named list with the hierarchical structure required by
[`bubblechart`](https://dataraceredu.github.io/nivo.bubblechart/reference/bubblechart.md).
The structure is:

      list(
        name = <root_name>,
        children = list(
          list(name = ..., value = ..., color = ..., labelColor = ...),
          list(name = ..., value = ..., color = ..., labelColor = ...),
          ...
        )
      )
      

This output can be passed directly to the `data` parameter of
[`bubblechart`](https://dataraceredu.github.io/nivo.bubblechart/reference/bubblechart.md).

## Details

Most R users work with tabular data in data frames, but bubble charts
require hierarchical (nested list) structures. This function handles the
conversion automatically, allowing you to specify which columns contain
the bubble names, values, and colors.

The function is particularly useful when:

- You have data in a data frame and want to visualize it as a bubble
  chart

- Your data comes from a database query, CSV file, or API that returns
  tabular data

- You want to apply conditional coloring based on data values

- You need to dynamically generate chart data in Shiny applications

If your data frame doesn't have color columns, the function will use the
`default_color` and `default_label_color` parameters for all bubbles.
You can also mix and match - for example, providing a color column but
letting the function use the default label color.

## See also

[`bubblechart`](https://dataraceredu.github.io/nivo.bubblechart/reference/bubblechart.md)
for creating the visualization.

## Examples

``` r
# Example 1: Basic conversion with all columns present
df <- data.frame(
  name = c("Apple", "Banana", "Cherry"),
  value = c(100, 200, 150),
  color = c("#ff5f56", "#ffbd2e", "#27c93f"),
  labelColor = c("#ffffff", "#ffffff", "#ffffff")
)

bubble_data <- prepare_bubble_data(df)
str(bubble_data)
#> List of 2
#>  $ name    : chr "root"
#>  $ children:List of 3
#>   ..$ :List of 4
#>   .. ..$ name      : chr "Apple"
#>   .. ..$ value     : num 100
#>   .. ..$ color     : chr "#ff5f56"
#>   .. ..$ labelColor: chr "#ffffff"
#>   ..$ :List of 4
#>   .. ..$ name      : chr "Banana"
#>   .. ..$ value     : num 200
#>   .. ..$ color     : chr "#ffbd2e"
#>   .. ..$ labelColor: chr "#ffffff"
#>   ..$ :List of 4
#>   .. ..$ name      : chr "Cherry"
#>   .. ..$ value     : num 150
#>   .. ..$ color     : chr "#27c93f"
#>   .. ..$ labelColor: chr "#ffffff"

# Example 2: Using custom column names
sales_df <- data.frame(
  product = c("Laptop", "Phone", "Tablet"),
  revenue = c(45000, 38000, 22000),
  brand_color = c("#3498db", "#e74c3c", "#f39c12")
)

chart_data <- prepare_bubble_data(
  sales_df,
  name_col = "product",
  value_col = "revenue",
  color_col = "brand_color",
  default_label_color = "#ffffff"
)

# Example 3: Using default colors (no color columns)
simple_df <- data.frame(
  category = c("A", "B", "C", "D"),
  amount = c(50, 120, 80, 200)
)

bubble_data <- prepare_bubble_data(
  simple_df,
  name_col = "category",
  value_col = "amount",
  default_color = "#9b59b6",        # Purple
  default_label_color = "#ffffff"   # White
)

# Example 4: Conditional coloring based on values
data_df <- data.frame(
  item = c("Small", "Medium", "Large", "X-Large"),
  size = c(50, 150, 300, 500)
)

# Add colors based on size
data_df$color <- ifelse(data_df$size > 250, "#27ae60",  # Green for large
                 ifelse(data_df$size > 100, "#f39c12",  # Orange for medium
                        "#e74c3c"))                      # Red for small
data_df$labelColor <- "#ffffff"

bubble_data <- prepare_bubble_data(data_df, name_col = "item", value_col = "size")

# Example 5: Use with bubblechart
if (FALSE) { # \dontrun{
library(nivo.bubblechart)

df <- data.frame(
  fruit = c("Apples", "Oranges", "Bananas", "Grapes"),
  sales = c(450, 280, 320, 150)
)

chart_data <- prepare_bubble_data(
  df,
  name_col = "fruit",
  value_col = "sales",
  default_color = "#3498db",
  default_label_color = "#ffffff"
)

bubblechart(
  element_id = "fruit_sales",
  main_color = "#3498db",
  label_color = "#ffffff",
  on_hover_title_color = "#2c3e50",
  data = chart_data,
  height = "500px"
)
} # }
```
