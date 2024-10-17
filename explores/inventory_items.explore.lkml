include: "/refined_views/r_products.view.lkml"
include: "/refined_views/r_inventory_items.view.lkml"
include: "/refined_views/r_distribution_centers.view.lkml"

explore: inventory_items {
  persist_with: default
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}
