
## `nivo.bubblechart` Package Documentation

The `nivo.bubblechart` package is an R interface to the `nivo.rocks`
library, specifically designed for creating interactive bubble charts.
The `nivo.rocks` library is a powerful and flexible data visualization
library built on top of React and D3. The `nivo.bubblechart` package
allows R users to easily integrate these bubble charts into their Shiny
applications.

## Installation

### Install the Development Version

Since the package is still under development, you can install the latest
version directly from GitHub using the `remotes` package. This ensures
that you have access to the most recent features and updates.

``` r
# Install the remotes package if you haven't already
install.packages("remotes")

# Install the development version of nivo.bubblechart
remotes::install_github('DataRacerEdu/nivo.bubblechart')
```

## Example Usage in a Shiny Application

Below is a full example of how to use the `nivo.bubblechart` package in
a Shiny app.

### Load Required Libraries

``` r
library(shiny)
library(nivo.bubblechart)
library(jsonlite)
```

### Prepare the Data

First, we need to prepare the data that will be visualized in the bubble
chart. This is done using a nested list structure, which is then
converted to JSON format.

``` r
json_data <- list(
  name = "nivo",
  children = list(
    list(
      name = "One",
      color = "#ffa970",
      labelColor = "#ffffff",
      value = 269
    ),
    list(
      name = "Two",
      color = "#ffa970",
      labelColor = "#ffffff",
      value = 4705
    ),
    list(
      name = "Three",
      color = "#ffa970",
      labelColor = "#ffffff",
      value = 643
    )
  )
) |> jsonlite::toJSON(na = 'null', pretty = TRUE, auto_unbox = TRUE)
```

### Define the User Interface (UI)

The UI is defined using `fluidPage`, where the bubble chart output is
placed using `bubblechartOutput`.

``` r
ui <- fluidPage(
  titlePanel("`nivo.bubblechart` example"),
  bubblechartOutput('widgetOutput')
)
```

### Define the Server Logic

The server logic is where the bubble chart is rendered using
`renderBubblechart`. The chart is interactive, and any clicks on the
bubbles can trigger events, which are handled using `observeEvent`.

``` r
server <- function(input, output, session) {
  output$widgetOutput <- renderBubblechart(
    bubblechart(
      element_id = "bubble_el",
      data = json_data,
      main_color = "#ffa970",
      label_color = "#ffffff",
      on_hover_title_color = "#ffa970",
      isInteractive = TRUE
    )
  )

  observeEvent(input$bubble_el_clicked, {
    print(input$bubble_el_clicked)
  })
}
```

### Launch the Shiny App

Finally, the Shiny app is launched using `shinyApp`.

``` r
shinyApp(ui, server)
```

### Example Output

Below is an example image of the Shiny app’s output. The chart displays
three bubbles, each with different values, colors, and labels.

<img src="../../../../Library/R/arm64/4.2/library/nivo.bubblechart/images/image1.png" width="100%" />

<img src="../../../../Library/R/arm64/4.2/library/nivo.bubblechart/images/image2.png" width="100%" />

## Explanation of Key Functions and Parameters

### `bubblechartOutput(outputId)`

This function is used in the UI to create a placeholder for the bubble
chart. The `outputId` should match the ID used in the
`renderBubblechart` function in the server logic.

### `renderBubblechart(expr)`

This function is used in the server logic to render the bubble chart.
The `expr` is an expression that generates the bubble chart using the
`bubblechart` function.

### `bubblechart(...)`

The `bubblechart` function is the main function that creates the bubble
chart object. It takes several parameters, including:

- `element_id`: The ID of the HTML element where the chart will be
  rendered.
- `data`: The data for the chart in JSON format.
- `main_color`: The main color of the bubbles.
- `label_color`: The color of the labels on the bubbles.
- `on_hover_title_color`: The color of the title when a bubble is
  hovered.
- `isInteractive`: A boolean indicating whether the chart is
  interactive.

### Interactivity and Event Handling

The `observeEvent` function is used to listen for events such as clicks
on the bubbles. The event is captured using the input ID followed by
`_clicked`. In this example, `input$bubble_el_clicked` captures the
click event on any bubble in the chart.
