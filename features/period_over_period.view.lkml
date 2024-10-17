view: period_over_period {

  extension: required

  #######################
  #   DATE SELECTIONS   #
  #######################

  filter: current_date_range {
    type: date
    view_label: "-- Period over Period"
    label: "Date Range"
    description: "Select the date range you are interested in using this filter, can be used by itself. Make sure any filter on the Date covers this period, or is removed."
    sql: (${pop_no_tz_date} between @{selected_period_start} and ifnull(@{selected_period_end}, '9999-01-01')) or (${pop_no_tz_date} between @{comparison_period_start} and ifnull(@{comparison_period_end}, '9999-01-01')) ;;
    convert_tz: yes
  }

  filter: comparison_date_range {
    type: date
    view_label: "-- Period over Period"
    label: "Date Range [comparison]"
    description: "Select the comparison date range you are interested in using this filter, can be used by itself. Make sure any filter on the Date covers this period, or is removed."
    sql: ${period} IS NOT NULL ;;
    convert_tz: yes
  }

  filter: is_within_current_selection {
    hidden: yes
    view_label: "-- Period over Period"
    type: yesno
    sql: ${pop_no_tz_date} between @{selected_period_start} and @{selected_period_end} ;;
  }

  parameter: time_period_selection {
    view_label: "-- Period over Period"
    type: unquoted
    allowed_value: { label: "No Comparison"   value: "Current" }
    allowed_value: { label: "Adjusted Previous Year"   value: "Adjusted_Year" }
    allowed_value: { label: "Previous Year"   value: "Year" }
    allowed_value: { label: "Previous Period" value: "Period" }
    allowed_value: { label: "Comparison Date Range" value: "Comparison" }
  }

  parameter: time_measure_selection {
    view_label: "-- Period over Period"
    type: unquoted
    allowed_value: {label: "MTD"  value: "mtd"}
    allowed_value: {label: "LFD"  value: "lfd"}
    allowed_value: {label: "L7D"  value: "l7d"}
    allowed_value: {label: "L28D"  value: "l28d"}
    allowed_value: {label: "YTD"  value: "ytd"}
    allowed_value: {label: "L12M" value: "l12m"}
    allowed_value: {label: "L3M" value: "l3m"}
    allowed_value: {label: "L6M" value: "l6m"}
    allowed_value: {label: "L9M" value: "l9m"}
    allowed_value: {label: "DateRange"  value: "daterange"}
    allowed_value: {label: "From start"  value: "from_start"}
    allowed_value: {label: "x KPIs"  value: "xkpis"}
    default_value: "daterange"
  }


  dimension_group: pop_no_tz {
    hidden: yes
    view_label: "-- Period over Period"
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      fiscal_year,
      fiscal_quarter,
      fiscal_quarter_of_year,
      fiscal_month_num
    ]
    convert_tz: no
  }

  dimension: is_mtd {
    view_label: "-- Period over Period"
    hidden: yes
    type: yesno
    sql: extract(day from ${pop_no_tz_date}) < extract(day from current_date) ;;
  }

  dimension: day_in_period {
    hidden: yes
    sql:
    {% if current_date_range._is_filtered %}
    CASE

      WHEN ${pop_no_tz_date} between @{selected_period_start} and ifnull(@{selected_period_end}, '9999-01-01')
      THEN DATE_DIFF(${pop_no_tz_date}, @{selected_period_start}, DAY )

      WHEN ${pop_no_tz_date} between @{comparison_period_start} and ifnull(@{comparison_period_end}, '9999-01-01')
      THEN DATE_DIFF(${pop_no_tz_date}, @{comparison_period_start}, DAY )

      END

      {% else %} NULL
      {% endif %} ;;
  }

  ##########################
  #   DIMENSIONS TO PLOT   #
  ##########################

  dimension: period {
    view_label: "-- Period over Period"
    label: "Period"
    description: "Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    sql:
    case

                  when ${pop_no_tz_date} between @{selected_period_start} and ifnull(@{selected_period_end}, '9999-01-01')
                  then 'Selected Period'

      when ${pop_no_tz_date} between @{comparison_period_start} and ifnull(@{comparison_period_end}, '9999-01-01')
      then 'Previous {% parameter time_period_selection %}'

      end ;;
  }

  dimension_group: date_in_period {
    view_label: "-- Period over Period"
    description: "Use this as your date dimension when comparing periods. Aligns the previous periods onto the current period"
    # label: "Current Period"
    label: "Selected"
    type: time
    sql: DATE_ADD(@{selected_period_start}, INTERVAL (${day_in_period}) DAY) ;;
    timeframes: [date, week, week_of_year, month, quarter, year, fiscal_year, fiscal_month_num, day_of_week_index, day_of_week  ]
  }



  dimension: week_day {
    #  hidden: yes
    view_label: "-- Period over Period"
    description: "Selected Date enrichment with Week & Day concatenation"
    # label: "Current Period"
    label: "Selected Date Week_Day"
    type: string
    sql:if(${date_in_period_week_of_year}<10,CONCAT("0", ${date_in_period_week_of_year},  "_",  ${date_in_period_day_of_week_index}+1 ), CONCAT("", ${date_in_period_week_of_year} , "_",  ${date_in_period_day_of_week_index}+1));;
    # value_format: "0#";;
    order_by_field: week_day_order
  }

  dimension: week_day_order {
    hidden: yes
    view_label: "-- Period over Period"
    description: "Selected Date enrichment with Week & Day concatenation. Technical dimension to order Selected Date Week_Day correctly."
    # label: "Current Period"
    label: "Selected Date Week_Day_order"
    type: string
    sql:if(${date_in_period_week_of_year}<10,CONCAT(EXTRACT(ISOYEAR FROM ${date_in_period_date} ), "0", ${date_in_period_week_of_year},  "_",  ${date_in_period_day_of_week_index}+1 ), CONCAT(EXTRACT(ISOYEAR FROM ${date_in_period_date} ),"", ${date_in_period_week_of_year} , "_",  ${date_in_period_day_of_week_index}+1));;
  }


  set: period_over_period_fields {
    fields: [
      current_date_range,
      comparison_date_range,
      is_within_current_selection,
      time_period_selection,
      time_measure_selection,
      is_mtd,
      day_in_period,
      period,
      date_in_period_date,
      date_in_period_week,
      date_in_period_month,
      date_in_period_quarter,
      date_in_period_year,
      date_in_period_fiscal_year
    ]
  }

  dimension: mtd_period {
    description: " Periods for MTD (Selected Period End) and MTD (Selected Period End -1 year) "
    group_label: "Dynamic Time Periods"
    label: "MTD Period"
    sql: CASE WHEN EXTRACT(YEAR FROM ${pop_no_tz_date}) = EXTRACT(YEAR FROM @{selected_period_end})
                   AND EXTRACT(MONTH FROM ${pop_no_tz_date}) = EXTRACT(MONTH FROM DATE_SUB(@{selected_period_end}, INTERVAL 1 DAY))
                   --Subtracting 1 day because, when using a Date Range filter
                   -- Looker creates a filter expression as selected_period_start AND (Until Before) (selected_period_end {} 1 day)
              THEN 'MTD'
              WHEN EXTRACT(YEAR FROM ${pop_no_tz_date}) = (EXTRACT(YEAR FROM @{selected_period_end}) -1)
                   AND EXTRACT(MONTH FROM ${pop_no_tz_date}) = EXTRACT(MONTH FROM DATE_SUB(@{selected_period_end}, INTERVAL 1 DAY))
                   --Subtracting 1 day because, when using a Date Range filter
                   -- Looker creates a filter expression as selected_period_start AND (Until Before) (selected_period_end + 1 day)

      THEN 'MTD (Previous Year)'
      ELSE NULL
      END ;;
  }

  dimension: last_3_6_9_12_months {
    group_label: "Dynamic Time Periods"
    label: "Last 3/6/9/12 months"
    description: "Periods for last 3months, 6months, 9months and 12months"
    order_by_field: last_3_6_9_12_month_sorting_dimension
    sql:
      CASE
        WHEN DATE(${pop_no_tz_date}) BETWEEN DATE_SUB(DATE(@{selected_period_end}), INTERVAL 3 MONTH) AND DATE(@{selected_period_end}) THEN 'Last 3 Months'
        WHEN DATE(${pop_no_tz_date}) BETWEEN DATE_SUB(DATE(@{selected_period_end}), INTERVAL 6 MONTH) AND DATE_SUB(DATE(@{selected_period_end}), INTERVAL 3 MONTH) THEN 'Last 6 Months'
        WHEN DATE(${pop_no_tz_date}) BETWEEN DATE_SUB(DATE(@{selected_period_end}), INTERVAL 9 MONTH) AND DATE_SUB(DATE(@{selected_period_end}), INTERVAL 6 MONTH) THEN 'Last 9 Months'
        WHEN DATE(${pop_no_tz_date}) BETWEEN DATE_SUB(DATE(@{selected_period_end}), INTERVAL 12 MONTH) AND DATE_SUB(DATE(@{selected_period_end}), INTERVAL 9 MONTH) THEN 'Last 12 Months'
        ELSE 'Other'
      END

      ;;
  }

  dimension: last_3_6_9_12_month_sorting_dimension {
    group_label: "Dynamic Time Periods"
    label: "Sorting Dimension - 3/6/9/12"
    description: "3 months = 1, 6 months = 2, 9 months = 3, 12 months = 4"
    hidden: yes
    sql:
      CASE WHEN ${last_3_6_9_12_months} = 'Last 3 Months' THEN 1
           WHEN ${last_3_6_9_12_months} = 'Last 6 Months'THEN 2
           WHEN ${last_3_6_9_12_months} = 'Last 9 Months'THEN 3
           WHEN ${last_3_6_9_12_months} = 'Last 12 Months'THEN 4
           ELSE 5
           END
           ;;
  }

  dimension: last_6_months_period {
    label: "Last 6 Months Period"
    group_label: "Dynamic Time Periods"
    description: "Period for last 6 months (Selected Period End) and last 6 months (Selected Period End -1 year)"
    sql:
        CASE
            WHEN ${pop_no_tz_date} BETWEEN DATE_SUB(DATE(@{selected_period_end}), INTERVAL 6 MONTH) AND @{selected_period_end}
            THEN 'Last 6 Months'
            WHEN ${pop_no_tz_date} BETWEEN DATE_SUB(DATE(@{selected_period_end}), INTERVAL 12 MONTH) AND DATE_SUB(DATE(@{selected_period_end}), INTERVAL 6 MONTH)
            THEN 'Last 6 Months (Previous Period)'
            ELSE NULL
              END
        ;;
  }

  dimension_group: selected_period_end {
    hidden: yes
    type: time
    timeframes: [year, month, month_name, month_num]
    sql: @{selected_period_end} ;;
  }

  dimension: selected_period_end_month_display {
    hidden: yes
    view_label: "-- Period over Period"
    type: string
    sql: CONCAT(${selected_period_end_month_name}, ' ', ${selected_period_end_year}) ;;
  }


}

#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
