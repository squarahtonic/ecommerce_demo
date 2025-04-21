include: "/views/inventory_items.view.lkml"

view: +inventory_items {

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: cost {
    type: number
    value_format_name: usd
  }

  dimension: product_brand {
    type: string
    link: {
      label: "Explore to Brand"
      url: "/explore/thelook_ecommerce/order_items?fields=inventory_items.product_name,order_items.m_sum_sale_price&f[inventory_items.product_brand]={{value | url_encode }}"
    }
  }

  dimension: product_category {
  }


  dimension: product_department {
  }

  dimension: product_distribution_center_id {
    hidden: yes
  }

  dimension: product_id {
    hidden: yes
  }

  dimension: product_name {
    type: string
  }

  dimension: product_retail_price {
    value_format_name: usd
  }

  dimension: product_sku {
  }

  dimension_group: sold {
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
    sql: ${TABLE}.sold_at ;;
  }

  measure: m_total_cost {
    label: "Total Cost"
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: m_average_cost {
    label: "Average Cost"
    type: average
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: m_count_distinct_sku {
    label: "Distinct Skus"
    type: count_distinct
    sql: ${product_sku} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }

 }
