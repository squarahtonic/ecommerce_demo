include: "/views/products.view.lkml"

view: +products {

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format_name: id
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Search"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | encode_uri }}.com"
    }
    link: {
      label: "{{value}} Business Pulse"
      url: "/dashboards/4?Brand={{ value | encode_uri }}"
      icon_url: "https://cloud.google.com/favicon.ico"
    }
    html: <a href="/dashboards/3?NameFilter={{ value }}" >{{ value }}</a> ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "View Category Details"
      url: "/explore/ecommerce_demo/inventory_items?fields=products.category,inventory_items.product_name,products.count&f[products.category]={{value | url_encode }}"
    }
    link: {
      label: "View Category Look"
      url: "/looks/3?fields=products.category,inventory_items.product_name,products.count&f[products.category]={{value | url_encode }}"
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

## Parameter

  parameter: select_product_detail {
    type: unquoted
    default_value: "department"
    allowed_value: {
      value: "department"
      label: "Department"
    }
    allowed_value: {
      value: "category"
      label: "Category"
    }
    allowed_value: {
      value: "brand"
      label: "Brand"
    }
  }

  dimension: product_hierarchy {
    label_from_parameter: select_product_detail
    type: string
    sql:
    {% if select_product_detail._parameter_value ==  'department' %}
    ${department}
    {% elsif select_product_detail._parameter_value == 'category' %}
    ${category}
    {% else %}
    ${brand}
    {% endif %} ;;
  }



}

## Dynamic Dimension }


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
