view: new_refined_views {

  dimension: age_tier {
    type: tier
    sql: ${TABLE}.age ;;
    tiers: [18,25,35,45,55,65,75,90]
  }
  }
