test: orders_2020_accuracy{
  explore_source: order_items {
    column: total_sale_price {}
    filters: {
      field: inventory_items.created_date
      value: "2020"
    }
  }
  assert: revenue_is_expected_value {
    expression: ${order_items.total_sale_price} = 2598901.6625026464 ;;
  }
 }


















test: order_items_id_is_unique {
  explore_source: order_items {
    column: id {}
    column: count {}
    sorts: [order_items.count: desc]
    limit: 1
  }
  assert: order_record_is_unique {
    expression: ${order_items.count} = 1 ;;
  }
  assert: order_id_is_not_null{
    expression: NOT is_null(${order_items.id}) ;;
  }
}
