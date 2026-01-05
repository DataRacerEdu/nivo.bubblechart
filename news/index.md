# Changelog

## nivo.bubblechart 0.1.0

### Initial Release

- First CRAN submission
- Interactive bubble chart (circle packing) visualization using Nivo
- Shiny integration with click and hover events
- Customizable colors, borders, and interactivity
- Comprehensive documentation and vignette
- Test suite with testthat
- Example Shiny application included

### Features

- Create hierarchical bubble charts from nested list data
- **NEW**:
  [`prepare_bubble_data()`](https://dataraceredu.github.io/nivo.bubblechart/reference/prepare_bubble_data.md)
  helper function to convert data frames to bubble chart format
- Click events accessible via Shiny input bindings
- Hover effects with customizable label colors
- Configurable bubble colors, label colors, and border styles
- Responsive design that works in RStudio Viewer and Shiny apps
- Built on the robust Nivo visualization library
- jsonlite integration for reliable data structure handling
