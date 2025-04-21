include: "/views/events.view.lkml"
include: "/refined_views/r_geography_dimensions.view.lkml"

view: +events {
  extends: [geography_dimensions]

  dimension: id {
    primary_key: yes
    hidden: yes
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
  }

  dimension: ip_address {
  }

  dimension: user_identifier {
    sql: COALESCE(CAST(${user_id} AS STRING), ${ip_address}) ;;
  }

  dimension: session_id {
  }

  dimension: sequence_number {
  }

  dimension: event_type {
  }

  dimension: traffic_source {
  }

  dimension: os {
  }

  dimension: browser {
  }

  dimension: uri {
  }

  measure: m_count_distinct_user_identifiers {
    label: "Distinct Users"
    type: count_distinct
    sql: ${user_identifier} ;;
  }

  measure: m_facebook {
    label: "Facebook users"
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
