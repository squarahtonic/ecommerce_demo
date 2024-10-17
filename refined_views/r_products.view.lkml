include: "/views/products.view.lkml"

view: +products {

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format_name: id
  }

  dimension: test  {
    label: "Test"
    sql: 1 ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;

    link: {
      label: "Website"
      url: "http://www.google.com/search?q={{ value | encode_uri }}+clothes&btnI"
      icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | encode_uri }}.com"
    }
    link: {
      label: "{{value}} Analytics Dashboard"
      url: "/dashboards/126?Brand%20Name={{ value | encode_uri }}"
      icon_url: "https://cloud.google.com/favicon.ico"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;

    link: {
      label: "View Category Details"
      url: "/explore/new_developers_workshop/inventory_items?fields=inventory_items.product_category,inventory_items.product_name,inventory_items.count&f[products.category]={{value | url_encode }}"
      icon_url: "https://cloud.google.com/favicon.ico"
    }
  }
  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }


## Dynamic Dimension {

  filter: choose_a_category_to_compare {
    type: string
    suggest_explore: inventory_items
    suggest_dimension: products.category
  }

  dimension: category_comparator {
    type: string
    sql:
      CASE
        WHEN {% condition choose_a_category_to_compare %}
                ${category}
             {% endcondition %}
        THEN ${category}
      ELSE 'All Other Categories'
      END
      ;;
  }

## Dynamic Dimension }
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
