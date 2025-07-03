include: "/views/users.view.lkml"
include: "/refined_views/r_geography_dimensions.view.lkml"
include: "/utilities/access_grants.lkml"

view: +users {
  extends: [geography_dimensions]

  dimension: id {
    hidden:  no
    primary_key: yes
    type: number
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
  }

  dimension: age {
    type: number
    value_format_name: decimal_0
  }

  dimension: age_tier {
    type: tier
    style: integer
    sql: ${TABLE}.age ;;
    tiers: [18, 25, 35, 45, 55, 65, 75, 85, 95, 100]
  }

  dimension: gender {
    type: string
  }

  dimension: traffic_source {
    type: string
  }

  dimension: is_email_source {
    type: yesno
    sql: ${traffic_source}="Email" ;;

  }

  measure: m_max_age {
    label: "Oldest Users"
    type: max
    sql: ${age} ;;
  }

  measure: m_average_age {
    label: "Average User Age"
    type: average
    sql: ${age} ;;
    value_format: "0"
  }

  measure: m_count_female_users {
    label: "Female Users"
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
