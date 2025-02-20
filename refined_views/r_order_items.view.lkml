include: "/views/order_items.view.lkml"
view: +order_items {

  ### Period on Period ###

  parameter: choose_breakdown {
    label: "Choose Grouping (Rows)"
    view_label: "_PoP"
    type: unquoted
    default_value: "year"
    allowed_value: {label: "Year" value: "year"}
    allowed_value: {label: "quarter" value: "quarter"}
    allowed_value: {label: "month" value: "month"}
  }

  parameter: choose_comparison {
    label: "Choose Comparison (Pivot)"
    view_label: "_PoP"
    type: unquoted
    default_value: "month"
    allowed_value: {value: "quarter" }
    allowed_value: {value: "month"}
  }

  dimension: pop_row  {
    view_label: "_PoP"
    label_from_parameter: choose_breakdown
    type: string
    order_by_field: sort_by1 # IMPORTANT - see description below
    sql:
    {% if choose_breakdown._parameter_value == 'year' %} ${created_year}
    {% elsif choose_breakdown._parameter_value == 'quarter' %} ${created_quarter_of_year}
    {% elsif choose_breakdown._parameter_value == 'month' %} ${created_month}
    {% else %}NULL{% endif %} ;;
  }

  dimension: pop_pivot {
    view_label: "_PoP"
    label_from_parameter: choose_comparison
    type: string
    order_by_field: sort_by2 # IMPORTANT - see description below
    sql:
    {% if choose_comparison._parameter_value == 'quarter' %} ${created_quarter_of_year}
    {% elsif choose_comparison._parameter_value == 'month' %} ${created_month_name}
    {% else %}NULL{% endif %} ;;
  }

# These dimensions are just to make sure the dimensions sort correctly

  dimension: sort_by1 {
    hidden: yes
    type: number
    sql:
    {% if choose_breakdown._parameter_value == 'year' %} ${created_year}
    {% elsif choose_breakdown._parameter_value == 'quarter' %} ${created_quarter_of_year}
    {% elsif choose_breakdown._parameter_value == 'month' %} ${created_month_num}
    {% else %}NULL{% endif %} ;;
  }

  dimension: sort_by2 {
    hidden: yes
    type: string
    sql:
    {% if choose_comparison._parameter_value == 'quarter' %} ${created_quarter_of_year}
    {% elsif choose_comparison._parameter_value == 'month' %} ${created_month_num}
    {% else %}NULL{% endif %} ;;
  }



  dimension: id {
    hidden:  no
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format_name: id
  }

  dimension_group: pop_no_tz {
    timeframes: [
      raw,
      date,
      week,
      month,
      month_name,
      month_num,
      quarter,
      year,
      fiscal_year,
      fiscal_quarter,
      fiscal_quarter_of_year,
      fiscal_month_num,
      quarter_of_year
    ]
    sql: ${created_date} ;;
  }

  dimension_group: created {
    description: "When the order was created"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      month_num,
      quarter,
      year,
      quarter_of_year

    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: reporting_period {
    description: "This Year to date versus Last Year to date"
    group_label: "Created Date"
    sql:  CASE
              WHEN EXTRACT(year FROM ${created_raw}) = EXTRACT(year FROM current_timestamp())
              AND ${created_raw} < current_timestamp()
              THEN 'This Year to Date'

      WHEN  EXTRACT(year FROM ${created_raw}) + 1 =  EXTRACT(year FROM current_timestamp())
      AND EXTRACT(DAYOFYEAR FROM ${created_raw}) <= EXTRACT(DAYOFYEAR FROM current_timestamp())
      THEN 'Last Year to Date'
      END ;;
  }

  dimension: months_since_signup {
    description: "Time between current order and when that user was created"
    type: number
    sql: DATEDIFF('month',${users.created_raw},${created_raw}) ;;
  }

  dimension_group: delivered {
    description: "When the order was delivered"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension_group: returned {
    description: "When the order was returned"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension_group: shipped {
    description: "When the order was shipped"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension_group: shipping_time {
    description: "Shipping time in days"
    type: duration
    intervals: [day]
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  dimension: sale_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price ;;
    html:
        {% if value <= 3 %}
        <p style="color: red">{{ rendered_value }}</p>
        {% elsif value > 3 %}
        <p style="color: blue">{{ rendered_value }}</p>
        {% else %}
        <p style="color: black">{{ rendered_value }}</p>
        {% endif %};;
  }

  dimension: gross_margin {
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  dimension: status {
    description: "Whether order is processing, shipped, completed, etc."
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: inventory_item_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.inventory_item_id ;;
    value_format_name: id
  }

  dimension: order_id {
    hidden:  no
    type: number
    sql: ${TABLE}.order_id ;;
    value_format_name: id
  }

  dimension: user_id {
    hidden: no
    type: number
    sql: ${TABLE}.user_id ;;
    value_format_name: id
  }

  dimension: profit {
    description: "Profit made on any one item"
    hidden:  yes
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  dimension: order_history_button {
    label: "History Button"
    sql: 1 ;;
    html: <a href="/explore/thelook_ecommerce/order_items?fields=order_items.detail*&f[users.id]={{ value }}"><button>Order History</button></a> ;;
  }

## MEASURES ##

  measure: order_item_count {
    type: count
    drill_fields: [detail*]
  }

  measure: order_count {
    description: "A count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
    drill_fields: [detail*]
  }

  measure: total_sale_price {
    alias: [total_revenue]
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
    html:
    {% if value <= 3 %}
    <p style="color: red">{{ rendered_value }}</p>
    {% elsif value > 3 %}
    <p style="color: blue">{{ rendered_value }}</p>
    {% else %}
    <p style="color: black">{{ rendered_value }}</p>
    {% endif %};;
  }

  measure: average_sale_price {
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

   measure: average_spend_per_user {
    type: number
    sql: ${total_sale_price}*1.0/nullif(${users.count},0) ;;
    value_format_name: usd
  }

  measure: total_sale_price_completed {
    label: "Total Sale Price from Completed Orders"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: {
      field: status
      value: "Complete"
    }
  }

  measure: total_sale_price_returned {
    label: "Total Sale Price Lost from Returns"
    description: "Sales not gained due to the ordered item being returned by the customer"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: {
      field: returned_date
      value: "-NULL"
    }
  }

  measure: total_profit {
    type: sum
    sql: ${profit} ;;
    value_format_name: usd
  }

  measure: profit_margin {
    type: number
    sql: ${total_profit}/NULLIF(${total_sale_price}, 0) ;;
    value_format_name: percent_2
  }

  measure: total_gross_margin {
    type: sum
    value_format_name: usd
    sql: ${gross_margin} ;;
    drill_fields: [detail*]
  }

  measure: average_shipping_time {
    type: average
    sql: ${days_shipping_time} ;;
    value_format: "0.00\" days\""
  }

# ----- Sets of fields for drilling ------
  set: detail {
    fields: [id, order_id, status, created_date, sale_price, products.brand, products.item_name, users.portrait, users.first_name, users.last_name, users.email]
  }

  parameter: select_timeframe {
    type: unquoted
    default_value: "created_month"
    allowed_value: {
      value: "created_date"
      label: "Date"
    }
    allowed_value: {
      value: "created_week"
      label: "Week"
    }
    allowed_value: {
      value: "created_month"
      label: "Month"
    }
  }

  dimension: dynamic_timeframe {
    label_from_parameter: select_timeframe
    type: string
    sql:
    {% if select_timeframe._parameter_value == 'created_date' %}
    ${created_date}
    {% elsif select_timeframe._parameter_value == 'created_week' %}
    ${created_week}
    {% else %}
    ${created_month}
    {% endif %} ;;
  }

}
