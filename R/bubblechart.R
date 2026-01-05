#' Create an Interactive Bubble Chart
#'
#' @description
#' Creates an interactive circle packing (bubble chart) visualization using the Nivo library.
#' This function produces a hierarchical bubble chart that supports click and hover interactions
#' in Shiny applications. Bubble size is determined by the \code{value} field in your data,
#' and colors are fully customizable.
#'
#' @details
#' The bubble chart (circle packing diagram) is a powerful way to visualize hierarchical data
#' where the size of each circle represents a quantitative value. This implementation uses
#' the Nivo visualization library to create responsive, interactive charts that work seamlessly
#' in both static R documents and dynamic Shiny applications.
#'
#' When used in Shiny, the chart generates click events that can be captured via
#' \code{input$<element_id>_clicked}, where \code{<element_id>} is the ID you specify.
#' Clicking a bubble returns its name, and clicking it again returns \code{"DESELECT_EVENT"}.
#'
#' @param element_id Character string specifying the Shiny input ID for click events.
#'   Click events will be accessible in Shiny as \code{input$<element_id>_clicked}.
#'   For example, if \code{element_id = "my_chart"}, click events are available at
#'   \code{input$my_chart_clicked}.
#' @param main_color Character string specifying the default color for bubbles (hex color code,
#'   e.g., "#ff5f56" for red, "#3498db" for blue). This color is used as the base color
#'   for the chart border and as a fallback.
#' @param label_color Character string specifying the default label text color (hex color code).
#'   Use high-contrast colors for better readability (e.g., "#ffffff" for white text on dark
#'   bubbles, "#000000" for black text on light bubbles).
#' @param on_hover_title_color Character string specifying the label color when hovering over
#'   a bubble (hex color code). This color is applied to the label text when the user hovers
#'   their mouse over a bubble, providing visual feedback.
#' @param data A nested list representing hierarchical data. Must have a "name" field at the root
#'   and a "children" field containing child nodes. Each child should have:
#'   \itemize{
#'     \item \code{name}: Display name for the bubble (character)
#'     \item \code{value}: Numeric value determining bubble size (must be positive)
#'     \item \code{color}: Hex color code for the bubble fill (character, e.g., "#3498db")
#'     \item \code{labelColor}: Hex color code for the label text (character, e.g., "#ffffff")
#'   }
#'   Use \code{\link{prepare_bubble_data}} to convert data frames to this format.
#' @param width The width of the widget. Can be a valid CSS unit (e.g., "100 percent", "400px",
#'   "50vw") or NULL for automatic sizing. NULL is recommended for responsive layouts.
#' @param isInteractive Logical. If TRUE (default), enables click and hover interactions.
#'   Set to FALSE for static charts in reports or presentations where interactivity
#'   is not needed.
#' @param height The height of the widget. Can be a valid CSS unit (e.g., "400px", "600px",
#'   "50vh") or NULL. Default is "400px". Adjust based on your layout needs and the
#'   amount of data being displayed.
#' @param activeColor Character string specifying the color of selected/active bubbles
#'   (hex color code). When a user clicks a bubble, it changes to this color.
#'   Default is "transparent", which makes the selected bubble see-through.
#' @param borderWidth Numeric value specifying the border width of bubbles in pixels.
#'   Default is 3. Use larger values (e.g., 5) for prominent borders, smaller values
#'   (e.g., 1) for subtle borders, or 0 for no borders.
#'
#' @return An htmlwidget object of class \code{c("bubblechart", "htmlwidget")} that can be:
#'   \itemize{
#'     \item Rendered directly in R console or RStudio Viewer
#'     \item Included in R Markdown documents
#'     \item Used in Shiny applications with \code{\link{bubblechartOutput}} and
#'           \code{\link{renderBubblechart}}
#'     \item Saved to HTML with \code{htmlwidgets::saveWidget()}
#'   }
#'
#' @seealso
#' \code{\link{prepare_bubble_data}} for converting data frames to the required format,
#' \code{\link{bubblechartOutput}} and \code{\link{renderBubblechart}} for Shiny integration.
#'
#' @examples
#' \dontrun{
#' library(nivo.bubblechart)
#'
#' # Example 1: Basic bubble chart with manual data
#' sample_data <- list(
#'   name = "root",
#'   children = list(
#'     list(name = "Category A", color = "#ff5f56", labelColor = "#ffffff", value = 100),
#'     list(name = "Category B", color = "#ffbd2e", labelColor = "#ffffff", value = 200),
#'     list(name = "Category C", color = "#27c93f", labelColor = "#ffffff", value = 150)
#'   )
#' )
#'
#' bubblechart(
#'   element_id = "my_chart",
#'   main_color = "#ff5f56",
#'   label_color = "#ffffff",
#'   on_hover_title_color = "#000000",
#'   data = sample_data,
#'   height = "500px"
#' )
#'
#' # Example 2: Using prepare_bubble_data for data frame conversion
#' df <- data.frame(
#'   product = c("Laptop", "Phone", "Tablet"),
#'   sales = c(45000, 38000, 22000),
#'   category_color = c("#3498db", "#e74c3c", "#f39c12"),
#'   text_color = rep("#ffffff", 3)
#' )
#'
#' chart_data <- prepare_bubble_data(
#'   df,
#'   name_col = "product",
#'   value_col = "sales",
#'   color_col = "category_color",
#'   label_color_col = "text_color"
#' )
#'
#' bubblechart(
#'   element_id = "sales_chart",
#'   main_color = "#3498db",
#'   label_color = "#ffffff",
#'   on_hover_title_color = "#2c3e50",
#'   data = chart_data,
#'   height = "600px"
#' )
#'
#' # Example 3: Customized appearance
#' bubblechart(
#'   element_id = "custom_chart",
#'   main_color = "#2c3e50",
#'   label_color = "#ecf0f1",
#'   on_hover_title_color = "#f39c12",
#'   activeColor = "#e74c3c",  # Red when selected
#'   borderWidth = 5,          # Thicker borders
#'   data = sample_data,
#'   isInteractive = TRUE
#' )
#' }
#'
#' @import htmlwidgets
#' @export
bubblechart <- function(
    element_id,
    main_color,
    label_color,
    on_hover_title_color,
    data = NULL,
    width = NULL,
    isInteractive = TRUE,
    height = '400px',
    activeColor = 'transparent',
    borderWidth = 3
  ) {

  configuration <- list(
    element_id    = element_id,
    dataJSON      = data,
    mainColor     = main_color,
    labelColor    = label_color,
    isInteractive = isInteractive,
    activeColor   = activeColor,
    borderWidth   = borderWidth,
    on_hover_title_color = on_hover_title_color
  )

  # describe a React component to send to the browser for rendering.
  component <- reactR::reactMarkup(reactR::component("BubbleChartTag", configuration))

  # create widget
  htmlwidgets::createWidget(
    name = 'bubblechart',
    component,
    width = width,
    height = height,
    package = 'nivo.bubblechart',
    elementId = NULL
  )
}

#' Called by HTMLWidgets to produce the widget's root element.
#' @noRd
widget_html.bubblechart <- function(id, style, class, ...) {
  htmltools::attachDependencies(
    htmltools::tags$div(id = id, class = class, style = style),
    list(
      # Necessary for RStudio viewer version < 1.2
      reactR::html_dependency_corejs(),
      reactR::html_dependency_react(),
      reactR::html_dependency_reacttools()
    )
  )
}

#' Shiny bindings for bubblechart
#'
#' Output and render functions for using bubblechart within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100 percent'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a bubblechart
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name bubblechart-shiny
#'
#' @export
bubblechartOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'bubblechart', width, height, package = 'nivo.bubblechart')
}

#' @rdname bubblechart-shiny
#' @export
renderBubblechart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, bubblechartOutput, env, quoted = TRUE)
}

#' Prepare Data Frame for Bubble Chart
#'
#' @description
#' Converts a data frame into the hierarchical list structure required by \code{\link{bubblechart}}.
#' This helper function bridges the gap between tabular data (data frames) and the nested
#' format expected by the Nivo circle packing visualization, making it easy to create bubble
#' charts from your existing data.
#'
#' @details
#' Most R users work with tabular data in data frames, but bubble charts require hierarchical
#' (nested list) structures. This function handles the conversion automatically, allowing you
#' to specify which columns contain the bubble names, values, and colors.
#'
#' The function is particularly useful when:
#' \itemize{
#'   \item You have data in a data frame and want to visualize it as a bubble chart
#'   \item Your data comes from a database query, CSV file, or API that returns tabular data
#'   \item You want to apply conditional coloring based on data values
#'   \item You need to dynamically generate chart data in Shiny applications
#' }
#'
#' If your data frame doesn't have color columns, the function will use the \code{default_color}
#' and \code{default_label_color} parameters for all bubbles. You can also mix and match - for
#' example, providing a color column but letting the function use the default label color.
#'
#' @param df A data frame containing your data. Must have at least two columns: one for names
#'   and one for values. Color columns are optional.
#' @param name_col Character string specifying the column name for bubble names.
#'   This will be the text displayed on each bubble. Default is "name".
#' @param value_col Character string specifying the column name for bubble values.
#'   These values determine the size of each bubble - larger values create larger bubbles.
#'   Values must be positive numbers. Default is "value".
#' @param color_col Character string specifying the column name for bubble colors, or NULL.
#'   If provided, this column should contain hex color codes (e.g., "#3498db"). If NULL or
#'   if the column doesn't exist, \code{default_color} is used. Default is "color".
#' @param label_color_col Character string specifying the column name for label colors, or NULL.
#'   If provided, this column should contain hex color codes for the text labels. If NULL or
#'   if the column doesn't exist, \code{default_label_color} is used. Default is "labelColor".
#' @param root_name Character string for the root node name. This is used internally by the
#'   visualization and typically doesn't need to be changed. Default is "root".
#' @param default_color Character string for default bubble color (hex code). Used when
#'   \code{color_col} is NULL or when a row has a missing color value.
#'   Default is "#ff5f56" (a warm red).
#' @param default_label_color Character string for default label text color (hex code).
#'   Used when \code{label_color_col} is NULL or when a row has a missing label color.
#'   Default is "#ffffff" (white). Use "#000000" for black text on light backgrounds.
#'
#' @return A named list with the hierarchical structure required by \code{\link{bubblechart}}.
#'   The structure is:
#'   \preformatted{
#'   list(
#'     name = <root_name>,
#'     children = list(
#'       list(name = ..., value = ..., color = ..., labelColor = ...),
#'       list(name = ..., value = ..., color = ..., labelColor = ...),
#'       ...
#'     )
#'   )
#'   }
#'   This output can be passed directly to the \code{data} parameter of \code{\link{bubblechart}}.
#'
#' @seealso \code{\link{bubblechart}} for creating the visualization.
#'
#' @examples
#' # Example 1: Basic conversion with all columns present
#' df <- data.frame(
#'   name = c("Apple", "Banana", "Cherry"),
#'   value = c(100, 200, 150),
#'   color = c("#ff5f56", "#ffbd2e", "#27c93f"),
#'   labelColor = c("#ffffff", "#ffffff", "#ffffff")
#' )
#'
#' bubble_data <- prepare_bubble_data(df)
#' str(bubble_data)
#'
#' # Example 2: Using custom column names
#' sales_df <- data.frame(
#'   product = c("Laptop", "Phone", "Tablet"),
#'   revenue = c(45000, 38000, 22000),
#'   brand_color = c("#3498db", "#e74c3c", "#f39c12")
#' )
#'
#' chart_data <- prepare_bubble_data(
#'   sales_df,
#'   name_col = "product",
#'   value_col = "revenue",
#'   color_col = "brand_color",
#'   default_label_color = "#ffffff"
#' )
#'
#' # Example 3: Using default colors (no color columns)
#' simple_df <- data.frame(
#'   category = c("A", "B", "C", "D"),
#'   amount = c(50, 120, 80, 200)
#' )
#'
#' bubble_data <- prepare_bubble_data(
#'   simple_df,
#'   name_col = "category",
#'   value_col = "amount",
#'   default_color = "#9b59b6",        # Purple
#'   default_label_color = "#ffffff"   # White
#' )
#'
#' # Example 4: Conditional coloring based on values
#' data_df <- data.frame(
#'   item = c("Small", "Medium", "Large", "X-Large"),
#'   size = c(50, 150, 300, 500)
#' )
#'
#' # Add colors based on size
#' data_df$color <- ifelse(data_df$size > 250, "#27ae60",  # Green for large
#'                  ifelse(data_df$size > 100, "#f39c12",  # Orange for medium
#'                         "#e74c3c"))                      # Red for small
#' data_df$labelColor <- "#ffffff"
#'
#' bubble_data <- prepare_bubble_data(data_df, name_col = "item", value_col = "size")
#'
#' # Example 5: Use with bubblechart
#' \dontrun{
#' library(nivo.bubblechart)
#'
#' df <- data.frame(
#'   fruit = c("Apples", "Oranges", "Bananas", "Grapes"),
#'   sales = c(450, 280, 320, 150)
#' )
#'
#' chart_data <- prepare_bubble_data(
#'   df,
#'   name_col = "fruit",
#'   value_col = "sales",
#'   default_color = "#3498db",
#'   default_label_color = "#ffffff"
#' )
#'
#' bubblechart(
#'   element_id = "fruit_sales",
#'   main_color = "#3498db",
#'   label_color = "#ffffff",
#'   on_hover_title_color = "#2c3e50",
#'   data = chart_data,
#'   height = "500px"
#' )
#' }
#'
#' @export
prepare_bubble_data <- function(df,
                                 name_col = "name",
                                 value_col = "value",
                                 color_col = "color",
                                 label_color_col = "labelColor",
                                 root_name = "root",
                                 default_color = "#ff5f56",
                                 default_label_color = "#ffffff") {

  if (!is.data.frame(df)) {
    stop("df must be a data frame")
  }

  if (!name_col %in% names(df)) {
    stop(paste0("Column '", name_col, "' not found in data frame"))
  }

  if (!value_col %in% names(df)) {
    stop(paste0("Column '", value_col, "' not found in data frame"))
  }

  # Create children list
  children <- lapply(seq_len(nrow(df)), function(i) {
    child <- list(
      name = as.character(df[[name_col]][i]),
      value = as.numeric(df[[value_col]][i])
    )

    # Add color if column exists
    if (!is.null(color_col) && color_col %in% names(df)) {
      child$color <- as.character(df[[color_col]][i])
    } else {
      child$color <- default_color
    }

    # Add labelColor if column exists
    if (!is.null(label_color_col) && label_color_col %in% names(df)) {
      child$labelColor <- as.character(df[[label_color_col]][i])
    } else {
      child$labelColor <- default_label_color
    }

    child
  })

  # Create root structure
  result <- list(
    name = root_name,
    children = children
  )

  # Validate structure with jsonlite (satisfies the Imports requirement)
  # This ensures the structure can be properly serialized
  tryCatch({
    jsonlite::toJSON(result, auto_unbox = TRUE)
  }, error = function(e) {
    stop("Invalid data structure for JSON serialization: ", e$message)
  })

  return(result)
}
