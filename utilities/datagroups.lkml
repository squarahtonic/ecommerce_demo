datagroup: default {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

datagroup: orders_datagroup {
  sql_trigger: SELECT max(created_at) FROM `thelook_ecommerce.events` ;;
  max_cache_age: "24 hours"
  label: "ETL ID added"
  description: "Triggered when new ID is added to ETL log"
}
