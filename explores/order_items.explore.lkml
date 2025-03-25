include: "/refined_views/*.view" # include all the views
include: "/derived_tables/*.view"


explore: order_items {

  label: "Orders"
  description: "This explore allows you to analyse sales orders"

  # access_filter: {
  #   field: users.country
  #   user_attribute: country
  # }
  # persist_for: "24 hours"

  persist_with: orders_datagroup

#  access_filter: {
#    field: users.city
#    user_attribute: location
#  }


  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: brand_order_facts_ndt {
    type: inner
    sql_on: ${products.brand} = ${brand_order_facts_ndt.brand};;
    relationship: one_to_one
  }

  join: user_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_facts.user_id} ;;
    relationship: one_to_one
  }
}

# Place in `thelook_ecommerce` model
# explore: +order_items {
#  aggregate_table: rollup__created_date {
#    query: {
#      dimensions: [created_date]
#      measures: [count]
#      timezone: "UTC"
#    }

#    materialization: {
#      datagroup_trigger: orders_datagroup
#    }
#  }
#}
