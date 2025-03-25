include: "/views/users.view.lkml"
include: "/refined_views/r_geography_dimensions.view.lkml"
include: "/utilities/access_grants.lkml"

view: +users {
  extends: [geography_dimensions]

  dimension: id {
    hidden:  no
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format_name: id
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: since_sign_up {
    type: duration
    intervals: [day]
    sql_start: ${created_date} ;;
    sql_end: current_date () ;;
  }

  dimension: days_since_signup_tier {
    type: tier
    sql: ${days_since_sign_up} ;;
    tiers: [0,90,180,500]
    style: integer
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_sign_up} < 600 ;;
  }

  dimension: years_a_customer {
    type: number
    value_format_name: decimal_0
    sql: DATEDIFF(year, ${created_date}, current_date) ;;
  }

  dimension: first_name {
    hidden:  no
    type: string
    sql: INITCAP(${TABLE}.first_name) ;;
  }

  dimension: last_name {
    hidden:  no
    type: string
    sql: INITCAP(${TABLE}.last_name) ;;
  }

  dimension: full_name {
    required_access_grants: [sensitive]
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: age {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    style: integer
    sql: ${TABLE}.age ;;
    tiers: [10, 20, 30, 40, 50, 60, 70, 80, 90]
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  measure: max_age {
    type: max
    sql: ${age} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
    value_format: "0"
  }

  measure: count_female_users {
    type: count
    filters: {
      field: gender
      value: "F"
    }
  }

  measure: count {
    type: count
    drill_fields: [id, events.count, order_items.count]
  }
}
