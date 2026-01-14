# Getting Started with nivo.bubblechart

## Introduction

Welcome to **nivo.bubblechart**. This package brings the power of
[Nivo’s](https://nivo.rocks) circle packing visualizations to R, making
it straightforward to create interactive bubble charts for data analysis
and Shiny applications.

**What are bubble charts?** Bubble charts (circle packing diagrams)
display hierarchical data as nested circles. The size of each bubble
represents a quantitative value, making it easy to compare magnitudes
across categories.

### Why use this package?

- **Clean defaults** - Charts look professional without extensive
  configuration
- **Customizable** - Control over colors, sizes, and interactions
- **Interactive** - Built-in hover effects and click event handling
- **Responsive** - Works across devices and screen sizes
- **Shiny integration** - First-class support for Shiny applications
- **Data frame support** - Easy conversion from data frames

------------------------------------------------------------------------

## Installation

### From CRAN

``` r
install.packages("nivo.bubblechart")
```

### Development Version

``` r
# Install from GitHub
# install.packages("devtools")
devtools::install_github("DataRacerEdu/nivo.bubblechart")
```

**Tip:** After installation, check out the example Shiny apps included
in the package.

------------------------------------------------------------------------

## Quick Start

### Basic Example

Create a bubble chart with a few lines of code:

``` r
library(nivo.bubblechart)

# Prepare data
fruit_data <- list(
  name = "Fruits",
  children = list(
    list(name = "Apples", value = 450, color = "#ff6b6b", labelColor = "#ffffff"),
    list(name = "Bananas", value = 320, color = "#feca57", labelColor = "#000000"),
    list(name = "Oranges", value = 280, color = "#ff9f43", labelColor = "#ffffff"),
    list(name = "Grapes", value = 150, color = "#a29bfe", labelColor = "#ffffff")
  )
)

# Create visualization
bubblechart(
  element_id = "fruit_chart",
  main_color = "#ff6b6b",
  label_color = "#ffffff",
  on_hover_title_color = "#2c3e50",
  data = fruit_data,
  height = "500px"
)
```

------------------------------------------------------------------------

## Data Structure

### Hierarchical Format

The package expects data as a nested list:

``` r
hierarchical_data <- list(
  name = "root",           # Root node name
  children = list(         # Child nodes
    list(
      name = "Item 1",     # Display name
      value = 100,         # Bubble size
      color = "#3498db",   # Fill color
      labelColor = "#fff"  # Text color
    ),
    list(
      name = "Item 2",
      value = 200,
      color = "#e74c3c",
      labelColor = "#fff"
    )
  )
)
```

#### Required Fields

| Field        | Type      | Description                               |
|--------------|-----------|-------------------------------------------|
| `name`       | character | Display name for the bubble               |
| `value`      | numeric   | Determines bubble size (must be positive) |
| `color`      | character | Hex color code for bubble fill            |
| `labelColor` | character | Hex color code for label text             |

**Note:** All bubbles must have the same structure. Missing fields may
cause rendering issues.

------------------------------------------------------------------------

## Working with Data Frames

### Using prepare_bubble_data()

Most R users work with data frames. The
[`prepare_bubble_data()`](https://dataraceredu.github.io/nivo.bubblechart/reference/prepare_bubble_data.md)
function handles the conversion:

#### Basic Conversion

``` r
# Data frame
sales_data <- data.frame(
  product = c("Laptop", "Phone", "Tablet", "Watch", "Headphones"),
  revenue = c(45000, 38000, 22000, 15000, 8000),
  category_color = c("#3498db", "#3498db", "#3498db", "#e74c3c", "#e74c3c"),
  text_color = c("#ffffff", "#ffffff", "#ffffff", "#ffffff", "#ffffff")
)

# Convert to bubble chart format
chart_data <- prepare_bubble_data(
  df = sales_data,
  name_col = "product",
  value_col = "revenue",
  color_col = "category_color",
  label_color_col = "text_color",
  root_name = "Product Sales"
)

# Create chart
bubblechart(
  element_id = "sales_chart",
  main_color = "#3498db",
  label_color = "#ffffff",
  on_hover_title_color = "#2c3e50",
  data = chart_data,
  height = "600px"
)
```

#### Using Default Colors

When your data doesn’t include color columns:

``` r
simple_data <- data.frame(
  category = c("Marketing", "Engineering", "Sales", "Support"),
  budget = c(120000, 250000, 180000, 90000)
)

chart_data <- prepare_bubble_data(
  df = simple_data,
  name_col = "category",
  value_col = "budget",
  default_color = "#9b59b6",
  default_label_color = "#ffffff"
)
```

#### Dynamic Color Mapping

Assign colors based on data values:

``` r
company_data <- data.frame(
  department = c("HR", "IT", "Finance", "Operations", "R&D"),
  employees = c(25, 150, 40, 200, 80)
)

# Color by department size
company_data$color <- ifelse(
  company_data$employees > 100, "#27ae60",
  ifelse(company_data$employees > 50, "#f39c12", "#e74c3c")
)
company_data$labelColor <- "#ffffff"

chart_data <- prepare_bubble_data(company_data)
```

------------------------------------------------------------------------

## Customization

### Color Parameters

``` r
bubblechart(
  element_id = "color_demo",
  main_color = "#3498db",           # Default bubble color
  label_color = "#ecf0f1",          # Default label color
  activeColor = "transparent",       # Selected bubble color
  on_hover_title_color = "#e74c3c", # Hover label color
  borderWidth = 2,                   # Border thickness
  data = your_data
)
```

### Color Palettes

Some tested combinations:

``` r
# Ocean theme
ocean_colors <- list(
  main = "#006ba6",
  label = "#ffffff",
  hover = "#0496ff"
)

# Sunset theme
sunset_colors <- list(
  main = "#ff6b6b",
  label = "#ffffff",
  hover = "#4ecdc4"
)

# Dark theme
dark_colors <- list(
  main = "#2c3e50",
  label = "#ecf0f1",
  hover = "#3498db"
)
```

### Sizing

``` r
# Responsive
bubblechart(
  element_id = "responsive_chart",
  data = your_data,
  width = "100%",
  height = "600px"
)

# Fixed dimensions
bubblechart(
  element_id = "fixed_chart",
  data = your_data,
  width = "800px",
  height = "600px"
)
```

### Interactivity

Disable interactions for static output:

``` r
bubblechart(
  element_id = "static_viz",
  data = your_data,
  isInteractive = FALSE
)
```

------------------------------------------------------------------------

## Shiny Integration

### Complete Example

``` r
library(shiny)
library(nivo.bubblechart)

sample_data <- list(
  name = "Tech Companies",
  children = list(
    list(name = "Apple", value = 2800, color = "#A3AAAE", labelColor = "#000000"),
    list(name = "Microsoft", value = 2500, color = "#00A4EF", labelColor = "#ffffff"),
    list(name = "Google", value = 1800, color = "#4285F4", labelColor = "#ffffff"),
    list(name = "Amazon", value = 1600, color = "#FF9900", labelColor = "#000000"),
    list(name = "Meta", value = 900, color = "#0668E1", labelColor = "#ffffff")
  )
)

ui <- fluidPage(
  titlePanel("Market Cap Visualization"),
  sidebarLayout(
    sidebarPanel(
      h4("Selected Company"),
      verbatimTextOutput("selected_company")
    ),
    mainPanel(
      bubblechartOutput("tech_chart", height = "600px")
    )
  )
)

server <- function(input, output, session) {

  output$tech_chart <- renderBubblechart({
    bubblechart(
      element_id = "tech_bubble",
      main_color = "#667eea",
      label_color = "#ffffff",
      on_hover_title_color = "#FFD700",
      activeColor = "#FF6B6B",
      borderWidth = 2,
      data = sample_data,
      height = "600px"
    )
  })

  output$selected_company <- renderPrint({
    clicked <- input$tech_bubble_clicked

    if (is.null(clicked)) {
      cat("Click a bubble to select")
    } else if (clicked == "DESELECT_EVENT") {
      cat("Deselected")
    } else {
      cat("Selected:", clicked)
    }
  })
}

shinyApp(ui, server)
```

### Click Event Handling

``` r
server <- function(input, output, session) {

  observeEvent(input$my_chart_clicked, {
    clicked_item <- input$my_chart_clicked

    if (clicked_item == "DESELECT_EVENT") {
      showNotification("Deselected", type = "message")
    } else {
      showNotification(paste("Selected:", clicked_item), type = "message")
    }
  })
}
```

------------------------------------------------------------------------

## Use Cases

### Portfolio Allocation

``` r
portfolio <- data.frame(
  asset = c("Stocks", "Bonds", "Real Estate", "Cash"),
  amount = c(45000, 30000, 20000, 8000)
)

portfolio$color <- c("#e74c3c", "#f39c12", "#3498db", "#27ae60")
portfolio$labelColor <- "#ffffff"

portfolio_data <- prepare_bubble_data(
  portfolio,
  name_col = "asset",
  value_col = "amount"
)
```

### Website Analytics

``` r
web_traffic <- data.frame(
  page = c("Home", "Products", "Blog", "About"),
  visitors = c(15000, 8500, 6200, 2100),
  bounce_rate = c(0.35, 0.42, 0.28, 0.55)
)

# Color by bounce rate
web_traffic$color <- ifelse(
  web_traffic$bounce_rate < 0.3, "#27ae60",
  ifelse(web_traffic$bounce_rate < 0.5, "#f39c12", "#e74c3c")
)
web_traffic$labelColor <- "#ffffff"

traffic_data <- prepare_bubble_data(
  web_traffic,
  name_col = "page",
  value_col = "visitors"
)
```

------------------------------------------------------------------------

## Best Practices

**Recommendations:**

- Use positive numeric values only
- Limit to 5-7 colors for readability
- Avoid extreme size differences between bubbles
- Test data structure with [`str()`](https://rdrr.io/r/utils/str.html)
  before visualizing
- Use high contrast colors for accessibility

### Performance

For large datasets, aggregate before visualizing:

``` r
large_data <- your_data %>%
  group_by(category) %>%
  summarise(total = sum(value), .groups = 'drop') %>%
  head(20)

chart_data <- prepare_bubble_data(
  large_data,
  name_col = "category",
  value_col = "total"
)
```

------------------------------------------------------------------------

## Troubleshooting

### Bubbles not appearing

``` r
# Verify structure
str(your_data)

# Check positive values
all(sapply(your_data$children, function(x) x$value > 0))

# Verify fields
names(your_data$children[[1]])
```

### Colors not displaying

``` r
# Convert factors to character
df$color <- as.character(df$color)
df$labelColor <- as.character(df$labelColor)
```

### Shiny events not firing

``` r
# element_id creates input$<id>_clicked
bubblechart(element_id = "my_chart", ...)

# Access as:
observeEvent(input$my_chart_clicked, { ... })
```

------------------------------------------------------------------------

## Function Reference

### bubblechart()

| Parameter              | Type      | Default       | Description          |
|------------------------|-----------|---------------|----------------------|
| `element_id`           | character | required      | Shiny input ID       |
| `main_color`           | character | required      | Default bubble color |
| `label_color`          | character | required      | Default label color  |
| `on_hover_title_color` | character | required      | Hover label color    |
| `data`                 | list      | NULL          | Hierarchical data    |
| `width`                | character | NULL          | Chart width          |
| `height`               | character | “400px”       | Chart height         |
| `isInteractive`        | logical   | TRUE          | Enable interactions  |
| `activeColor`          | character | “transparent” | Selected color       |
| `borderWidth`          | numeric   | 3             | Border width (px)    |

### prepare_bubble_data()

| Parameter             | Type       | Default      | Description          |
|-----------------------|------------|--------------|----------------------|
| `df`                  | data.frame | required     | Input data           |
| `name_col`            | character  | “name”       | Name column          |
| `value_col`           | character  | “value”      | Value column         |
| `color_col`           | character  | “color”      | Color column         |
| `label_color_col`     | character  | “labelColor” | Label color column   |
| `root_name`           | character  | “root”       | Root node name       |
| `default_color`       | character  | “#ff5f56”    | Fallback color       |
| `default_label_color` | character  | “#ffffff”    | Fallback label color |

------------------------------------------------------------------------

## Resources

- [Nivo Documentation](https://nivo.rocks/circle-packing/)
- [GitHub Repository](https://github.com/DataRacerEdu/nivo.bubblechart)
- [Report
  Issues](https://github.com/DataRacerEdu/nivo.bubblechart/issues)

------------------------------------------------------------------------

*Last updated: 2026-01-14*
