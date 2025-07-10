include: "/views/users.view.lkml"
include: "/refined_views/r_geography_dimensions.view.lkml"

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

  dimension: days_since_sign_up {
    type: number
    sql: DATEDIFF(day, ${created_raw}, current_date) ;;
    hidden: yes
  }

  dimension: days_since_signup_tier {
    type: tier
    sql: ${days_since_sign_up} ;;
    tiers: [0,90,180,500]
    style: integer
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_sign_up} < 90 ;;
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

#  dimension: full_name {
#    type: string
#    sql: ${first_name} || ' ' || ${last_name} ;;
#  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: age {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.age ;;
  }

  # dimension: age_tier {
  #   type: tier
  #   style: integer
  #   sql: ${TABLE}.age ;;
  #   tiers: [18,25,35,45,55,65,75,85,95,105]
  # }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: is_email_source {
    type: yesno
    sql: ${traffic_source}="Email" ;;

  }

  dimension: full_name {
    type: string
    sql: concat(${first_name},' ', ${last_name}) ;;
  }


  measure: max_age {
    type: max
    sql: ${age} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  measure: count_female_users {
    type: count
    filters: {
      field: gender
      value: "Female"
    }
  }

  measure: count {
    type: count
    drill_fields: [id, events.count, order_items.count]
  }

  measure: total_revenue_email_source {
    type: sum
    sql: ${TABLE}.sale_price ;;
    filters: [users.is_email_source: "Yes"]
    value_format_name: usd
  }
}
