- dashboard: brand_lookup
  title: Brand Lookup
  layout: newspaper
  preferred_viewer: dashboards-next
  query_timezone: user_timezone
  embed_style:
    background_color: "#f6f8fa"
    show_title: true
    title_color: "#3a4245"
    show_filters_bar: true
    tile_text_color: "#3a4245"
    text_tile_text_color: "#556d7a"
  elements:
  - name: <img src="https://directoriosvitocommx/wp-content/uploads/2018/06/proanlogojpg"
      height="75">
    type: text
    title_text: <img src="https://directoriosvito.com.mx/wp-content/uploads/2018/06/proanlogo.jpg"
      height="75">
    subtitle_text: What are the high level revenue metrics for this brand?
    body_text: ''
    row: 0
    col: 0
    width: 24
    height: 2
  - name: "<span class='fa fa-users'> Top Customers </span>"
    type: text
    title_text: "<span class='fa fa-users'> Top Customers </span>"
    subtitle_text: Who are our highest valued customers?
    body_text: "**Recommended Action** Explore from here to see what products a user\
      \ has purchased and include them in a targeted advertising campaign"
    row: 12
    col: 2
    width: 12
    height: 2
  - name: Category
    type: text
    title_text: Category
    subtitle_text: ''
    body_text: This is an example
    row: 12
    col: 14
    width: 10
    height: 2
  - title: Sales and Sale Price Trend
    name: Sales and Sale Price Trend
    model: thelook_ecommerce
    explore: order_items
    type: looker_line
    fields: [order_items.created_date, order_items.average_sale_price, order_items.total_sale_price]
    sorts: [order_items.created_date desc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: false
    show_null_points: true
    interpolation: monotone
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
      options:
        steps: 5
    y_axes: [{label: Total Sale Amount, orientation: left, series: [{axisId: order_items.total_revenue,
            id: order_items.total_revenue, name: Total Revenue}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: !!null '', orientation: right, series: [{axisId: order_items.average_sale_price,
            id: order_items.average_sale_price, name: Average Sale Price}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    y_axis_labels: [Total Sale Amount, Average Selling Price]
    x_axis_label: Order Date
    hide_legend: true
    colors: ["#F2B431", "#57BEBE"]
    series_colors:
      order_items.total_sale_price: "#B1399E"
      order_items.average_sale_price: "#72D16D"
    y_axis_orientation: [left, right]
    x_axis_datetime: true
    hide_points: true
    color_palette: Custom
    note_state: collapsed
    note_display: hover
    note_text: ''
    defaults_version: 1
    listen:
      Date: order_items.created_date
      State: users.state
      Brand Name: products.brand
    row: 5
    col: 12
    width: 12
    height: 7
  - title: Average Order Value
    name: Average Order Value
    model: thelook_ecommerce
    explore: order_items
    type: single_value
    fields: [order_items.average_sale_price]
    sorts: [order_items.average_sale_price desc]
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    font_size: medium
    text_color: black
    note_state: collapsed
    note_display: below
    note_text: ''
    listen:
      Date: order_items.created_date
      State: users.state
      Brand Name: products.brand
    row: 2
    col: 9
    width: 7
    height: 3
  - title: Top Purchasers of Brand
    name: Top Purchasers of Brand
    model: thelook_ecommerce
    explore: order_items
    type: looker_grid
    fields: [users.full_name, users.email, order_items.order_count, users.state, order_items.total_sale_price]
    sorts: [order_items.order_count desc]
    limit: 15
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    truncate_column_names: false
    conditional_formatting_ignored_fields: []
    series_types: {}
    defaults_version: 1
    listen:
      Date: order_items.created_date
      State: users.state
      Brand Name: products.brand
    row: 14
    col: 2
    width: 12
    height: 8
  - title: Category Orders
    name: Category Orders
    model: thelook_ecommerce
    explore: order_items
    type: looker_pie
    fields: [order_items.order_count, products.brand]
    sorts: [order_items.order_count desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    series_types: {}
    listen:
      Brand Name: products.brand
    row: 14
    col: 14
    width: 8
    height: 6
  - title: Most Popular Categories
    name: Most Popular Categories
    model: thelook_ecommerce
    explore: order_items
    type: looker_column
    fields: [products.category, products.department, order_items.total_sale_price]
    pivots: [products.department]
    sorts: [products.department, order_items.total_sale_price desc 0]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
      options:
        steps: 5
    series_types: {}
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: gray
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Brand Name: products.brand
    row: 5
    col: 0
    width: 12
    height: 7
  - title: Total Orders
    name: Total Orders
    model: thelook_ecommerce
    explore: order_items
    type: single_value
    fields: [order_items.order_count]
    sorts: [order_items.order_count desc]
    limit: 500
    query_timezone: America/Los_Angeles
    font_size: medium
    text_color: black
    listen:
      Date: order_items.created_date
      State: users.state
      Brand Name: products.brand
    row: 2
    col: 16
    width: 7
    height: 3
  - title: Total Customers
    name: Total Customers
    model: thelook_ecommerce
    explore: order_items
    type: single_value
    fields: [users.count]
    sorts: [users.count desc]
    limit: 500
    query_timezone: America/Los_Angeles
    font_size: medium
    text_color: black
    note_state: expanded
    note_display: above
    note_text: ''
    listen:
      Date: order_items.created_date
      State: users.state
      Brand Name: products.brand
    row: 2
    col: 2
    width: 7
    height: 3
  filters:
  - name: Brand Name
    title: Brand Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: thelook_ecommerce
    explore: order_items
    listens_to_filters: []
    field: products.brand
  - name: Date
    title: Date
    type: date_filter
    default_value: 90 days
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
  - name: State
    title: State
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: thelook_ecommerce
    explore: order_items
    listens_to_filters: []
    field: users.state