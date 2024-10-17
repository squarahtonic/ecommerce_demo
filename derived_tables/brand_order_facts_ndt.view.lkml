view: brand_order_facts_ndt {

  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_sale_price {}
      derived_column: brand_rank {
        sql: row_number() over (order by total_sale_price desc) ;;
      }
      # bind_all_filters: yes
    }
    # datagroup_trigger: orders_datagroup
  }

  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: brand {
    primary_key:yes
  }

  dimension: brand_rank {
    hidden: yes
    type: number
  }

  dimension: brand_rank_top_5 {
    type: yesno
    sql: ${brand_rank}<=5 ;;
  }

  dimension: ranked_brands {
    type: string
    sql: CASE
            WHEN ${brand_rank_top_5} THEN  CONCAT( CAST(${brand_rank} AS STRING), ') ', ${brand})
            ELSE '6) Other'
          END ;;
  }
}

#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
