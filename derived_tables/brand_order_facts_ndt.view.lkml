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
