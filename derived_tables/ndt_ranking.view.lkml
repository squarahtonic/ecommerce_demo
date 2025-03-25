view: ndt_ranking {
  derived_table: {
    explore_source: order_items {
      column: total_cost { field: inventory_items.total_cost }
      column: product_brand { field: inventory_items.product_brand }
      derived_column: ranking {sql:row_number() over (order by total_cost desc);;}
      limit: 10
    }
  }
  dimension: total_cost {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
  dimension: product_brand {
    description: ""
  }
  dimension: ranking {}
}
