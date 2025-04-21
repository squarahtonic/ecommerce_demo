
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
