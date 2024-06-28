#' Bubble Chart
#'
#' Nivo Bubble Chart
#'
#' @import htmlwidgets
#'
#' @export
bubblechart <- function(
    element_id,
    main_color,
    label_color,
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
    borderWidth   = borderWidth
  )

  # describe a React component to send to the browser for rendering.
  component <- reactR::reactMarkup(reactR::component("BubleChartTag", configuration))

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
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for bubblechart
#'
#' Output and render functions for using bubblechart within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
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
