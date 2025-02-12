include: "/views/inventory_items.view.lkml"

view: +inventory_items {

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
    sql: ${TABLE}.cost ;;
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
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
  }

  dimension: product_retail_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
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

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: average_cost {
    type: average
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: count_distinct_sku {
    type: count_distinct
    sql: ${product_sku} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }

 }
