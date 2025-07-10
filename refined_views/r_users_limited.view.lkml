view: users_limited-a {

  dimension: user_age_tier {
    description: "Age tier for Users"
    type:  tier
    sql: ${TABLE}.age ;;
    tiers: [18, 28, 38, 48, 58, 68, 78, 88, 98, 100]
  }

}
