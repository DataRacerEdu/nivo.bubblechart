test_that("bubblechart creates an htmlwidget", {
  sample_data <- list(
    name = "root",
    children = list(
      list(name = "A", color = "#ff5f56", labelColor = "#ffffff", value = 100),
      list(name = "B", color = "#ffbd2e", labelColor = "#ffffff", value = 200)
    )
  )

  chart <- bubblechart(
    element_id = "test_chart",
    main_color = "#ff5f56",
    label_color = "#ffffff",
    on_hover_title_color = "#000000",
    data = sample_data
  )

  expect_s3_class(chart, "htmlwidget")
  expect_s3_class(chart, "bubblechart")
})

test_that("bubblechart accepts custom parameters", {
  sample_data <- list(
    name = "root",
    children = list(
      list(name = "A", color = "#ff5f56", labelColor = "#ffffff", value = 100)
    )
  )

  chart <- bubblechart(
    element_id = "custom_chart",
    main_color = "#3498db",
    label_color = "#ecf0f1",
    on_hover_title_color = "#2c3e50",
    data = sample_data,
    height = "600px",
    width = "800px",
    isInteractive = FALSE,
    activeColor = "#e74c3c",
    borderWidth = 5
  )

  expect_s3_class(chart, "htmlwidget")
  expect_equal(chart$height, "600px")
  expect_equal(chart$width, "800px")
})

test_that("bubblechartOutput creates shiny output", {
  output <- bubblechartOutput("test_output")

  expect_s3_class(output, "shiny.tag.list")
})

test_that("renderBubblechart is a function", {
  expect_type(renderBubblechart, "closure")
})

test_that("prepare_bubble_data converts data frame correctly", {
  df <- data.frame(
    name = c("A", "B", "C"),
    value = c(100, 200, 150),
    color = c("#ff5f56", "#ffbd2e", "#27c93f"),
    labelColor = c("#ffffff", "#ffffff", "#ffffff")
  )

  result <- prepare_bubble_data(df)

  expect_type(result, "list")
  expect_equal(result$name, "root")
  expect_length(result$children, 3)
  expect_equal(result$children[[1]]$name, "A")
  expect_equal(result$children[[1]]$value, 100)
  expect_equal(result$children[[1]]$color, "#ff5f56")
})

test_that("prepare_bubble_data uses defaults when color columns missing", {
  df <- data.frame(
    name = c("A", "B"),
    value = c(100, 200)
  )

  result <- prepare_bubble_data(df)

  expect_equal(result$children[[1]]$color, "#ff5f56")
  expect_equal(result$children[[1]]$labelColor, "#ffffff")
})

test_that("prepare_bubble_data handles custom column names", {
  df <- data.frame(
    item = c("X", "Y"),
    amount = c(50, 75)
  )

  result <- prepare_bubble_data(df, name_col = "item", value_col = "amount")

  expect_equal(result$children[[1]]$name, "X")
  expect_equal(result$children[[1]]$value, 50)
})

test_that("prepare_bubble_data errors on missing columns", {
  df <- data.frame(x = c(1, 2))

  expect_error(prepare_bubble_data(df), "Column 'name' not found")
  expect_error(prepare_bubble_data(df, name_col = "x"), "Column 'value' not found")
})

test_that("prepare_bubble_data errors on non-data frame input", {
  expect_error(prepare_bubble_data(c(1, 2, 3)), "df must be a data frame")
})
