
view: r_users_limited {
  sql_table_name: `thelook_ecommerce.users` ;;

  dimension: user_age_tier {
    description: "Age tier for Users"
    type: tier
    sql: ${TABLE}.age;;
    tiers: [18,28,38,48,58,68,78,88,98,108]
  }

 }
