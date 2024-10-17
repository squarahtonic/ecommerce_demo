include: "/views/events.view.lkml"
include: "/refined_views/r_geography_dimensions.view.lkml"

view: +events {
  extends: [geography_dimensions]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  dimension: user_identifier {
    type: string
    sql: COALESCE(CAST(${user_id} AS STRING), ${ip_address}) ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: uri {
    type: string
    sql: ${TABLE}.uri ;;
  }

  measure: count_distinct_user_identifiers {
    type: count_distinct
    sql: ${user_identifier} ;;
  }

  measure: count_events_facebook {
    hidden: yes
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: traffic_source
      value: "Facebook"
    }
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name]
  }
}
