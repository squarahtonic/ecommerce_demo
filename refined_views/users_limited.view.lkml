view: users_limited {

dimension: age_tier {
  type:  tier
  tiers: [18, 25, 35, 45, 55, 65, 75, 90]
  sql: ${TABLE}.age ;;
}




}
