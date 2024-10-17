- dashboard: business_pulse
  title: Business Pulse
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Orders This Year
    name: Orders This Year
    model: thelook_ecommerce
    explore: order_items
    type: single_value
    fields: [order_items.order_count, order_items.reporting_period]
    filters:
      order_items.reporting_period: "-NULL"
    sorts: [order_items.order_count desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: from_this_time_last_year, label: from this
          time last year, expression: "${order_items.order_count}/offset(${order_items.order_count},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: "#8c6f35"
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    font_size: medium
    colors: ["#64518A", "#8D7FB9", "#EA8A2F", "#F2B431", "#20A5DE", "#57BEBE", "#7F7977",
      "#B2A898", "#494C52", purple]
    text_color: "#49719a"
    hidden_fields: []
    y_axes: []
    listen:
      State: users.state
      City: users.city
      Brand: products.brand
      Created Year: inventory_items.created_year
      Created Month Name: order_items.created_month_name
    row: 0
    col: 17
    width: 6
    height: 4
  - title: New Users Acquired
    name: New Users Acquired
    model: thelook_ecommerce
    explore: order_items
    type: single_value
    fields: [users.count]
    filters:
      users.created_date: 7 days
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: '10000', label: Goal,
        value_format: !!null '', value_format_name: decimal_0, _kind_hint: dimension,
        table_calculation: goal, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: New Users Acquired
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: Users created in the last 7 days.
    listen:
      Date: order_items.created_date
      State: users.state
      City: users.city
      Brand: products.brand
      Created Year: inventory_items.created_year
      Created Month Name: order_items.created_month_name
    row: 0
    col: 1
    width: 6
    height: 4
  - title: Average Spend Per User
    name: Average Spend Per User
    model: thelook_ecommerce
    explore: order_items
    type: single_value
    fields: [order_items.average_spend_per_user]
    sorts: [order_items.average_sale_price desc]
    limit: 500
    query_timezone: America/Los_Angeles
    font_size: medium
    colors: ["#64518A", "#8D7FB9", "#EA8A2F", "#F2B431", "#20A5DE", "#57BEBE", "#7F7977",
      "#B2A898", "#494C52", purple]
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    ordering: none
    show_null_labels: false
    text_color: black
    hidden_fields: []
    y_axes: []
    listen:
      Date: order_items.created_date
      State: users.state
      City: users.city
      Brand: products.brand
      Created Year: inventory_items.created_year
      Created Month Name: order_items.created_month_name
    row: 0
    col: 12
    width: 5
    height: 4
  - title: Orders by Day and Category
    name: Orders by Day and Category
    model: thelook_ecommerce
    explore: order_items
    type: looker_area
    fields: [order_items.created_date, products.category, order_items.order_item_count]
    pivots: [products.category]
    filters:
      products.category: Jeans,Accessories,Active,Dresses,Sleep & Lounge,Shorts
    sorts: [order_items.created_year desc, order_items.created_month_num, users.count_percent_of_total
        desc 0, products.department, users.traffic_source, products.category, order_items.created_date
        desc]
    limit: 500
    column_limit: 50
    query_timezone: America/New_York
    trellis: ''
    stacking: normal
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
      options:
        steps: 5
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_colors: {}
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    show_null_points: true
    interpolation: monotone
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    ordering: none
    show_null_labels: false
    hidden_fields: []
    y_axes: []
    listen:
      Date: order_items.created_date
      State: users.state
      City: users.city
      Brand: products.brand
      Created Year: inventory_items.created_year
      Created Month Name: order_items.created_month_name
    row: 4
    col: 1
    width: 22
    height: 8
  - title: Marketing Channel by User Demographic
    name: Marketing Channel by User Demographic
    model: thelook_ecommerce
    explore: order_items
    type: looker_donut_multiples
    fields: [products.department, users.traffic_source, users.count]
    pivots: [users.traffic_source]
    sorts: [order_items.created_year desc, order_items.created_month_num, users.count_percent_of_total
        desc 0, products.department, users.traffic_source]
    limit: 500
    column_limit: 50
    query_timezone: America/New_York
    show_value_labels: true
    font_size: 12
    colors: ["#64518A", "#8D7FB9", "#EA8A2F", "#F2B431", "#20A5DE", "#57BEBE", "#7F7977",
      "#B2A898", "#494C52", purple]
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
      options:
        steps: 5
    series_colors: {}
    stacking: ''
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    ordering: none
    show_null_labels: false
    show_view_names: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    value_labels: legend
    label_type: labPer
    hidden_fields: []
    y_axes: []
    listen:
      Date: order_items.created_date
      State: users.state
      City: users.city
      Brand: products.brand
      Created Year: inventory_items.created_year
      Created Month Name: order_items.created_month_name
    row: 20
    col: 6
    width: 11
    height: 7
  - title: Total Revenue, Year Over Year
    name: Total Revenue, Year Over Year
    model: thelook_ecommerce
    explore: order_items
    type: looker_line
    fields: [order_items.created_year, order_items.created_month_name, order_items.total_sale_price]
    pivots: [order_items.created_year]
    fill_fields: [order_items.created_month_name]
    sorts: [order_items.created_year 0, order_items.created_month_name]
    limit: 12
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    point_style: circle_outline
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: monotone
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      custom:
        id: 141984a4-e5e2-4602-c511-5e69169cea6c
        label: Custom
        type: discrete
        colors:
        - "#75E2E2"
        - "#3EB0D5"
        - "#4276BE"
        - "#592EC2"
        - "#9174F0"
        - "#B1399E"
      options:
        steps: 5
    series_colors: {}
    series_types: {}
    y_axes: [{label: '', orientation: left, series: [{id: 2014 - order_items.total_revenue,
            name: '2014', axisId: 2014 - order_items.total_revenue}, {id: 2015 - order_items.total_revenue,
            name: '2015', axisId: 2015 - order_items.total_revenue}, {id: 2016 - order_items.total_revenue,
            name: '2016', axisId: 2016 - order_items.total_revenue}, {id: 2017 - order_items.total_revenue,
            name: '2017', axisId: 2017 - order_items.total_revenue}, {id: 2018 - order_items.total_revenue,
            name: '2018', axisId: 2018 - order_items.total_revenue}, {id: 2019 - order_items.total_revenue,
            name: '2019', axisId: 2019 - order_items.total_revenue}], showLabels: false,
        showValues: true, valueFormat: '$0, "K"', unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_label: Order Month
    ordering: none
    show_null_labels: false
    hidden_fields: []
    defaults_version: 1
    listen:
      State: users.state
      City: users.city
      Brand: products.brand
      Created Year: inventory_items.created_year
      Created Month Name: order_items.created_month_name
    row: 12
    col: 1
    width: 11
    height: 8
  - title: Highest Spending Users
    name: Highest Spending Users
    model: thelook_ecommerce
    explore: order_items
    type: looker_map
    fields: [users.map_location, users.country, order_items.order_count, order_items.average_spend_per_user,
      order_items.total_sale_price]
    sorts: [order_items.order_count desc]
    limit: 500
    map_plot_mode: points
    heatmap_gridlines: true
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: custom
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: pixels
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map_latitude: 37.57941251343841
    map_longitude: -99.31640625000001
    map_zoom: 4
    map_marker_radius_max: 15
    map_marker_color: ["#4285F4", "#EA4335", "#FBBC04", "#34A853"]
    map_value_scale_clamp_max: 200
    hidden_fields: [users.country]
    defaults_version: 1
    listen:
      Date: order_items.created_date
      State: users.state
      City: users.city
      Brand: products.brand
      Created Year: inventory_items.created_year
      Created Month Name: order_items.created_month_name
    row: 12
    col: 12
    width: 11
    height: 8
  - title: Average Order Sale Price
    name: Average Order Sale Price
    model: thelook_ecommerce
    explore: order_items
    type: single_value
    fields: [order_items.average_sale_price]
    limit: 500
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
    listen:
      Date: order_items.created_date
      State: users.state
      City: users.city
      Brand: products.brand
      Created Year: inventory_items.created_year
      Created Month Name: order_items.created_month_name
    row: 0
    col: 7
    width: 5
    height: 4
  filters:
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
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: thelook_ecommerce
    explore: order_items
    listens_to_filters: [State]
    field: users.city
  - name: Brand
    title: Brand
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
    field: products.brand
  - name: Created Year
    title: Created Year
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
    field: order_items.created_year
  - name: Created Month Name
    title: Created Month Name
    type: field_filter
    default_value: January,February,March,April,May,June,July,August,September,October,November,December
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: thelook_ecommerce
    explore: order_items
    listens_to_filters: []
    field: order_items.created_month_name
