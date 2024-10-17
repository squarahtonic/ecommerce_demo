project_name: "ecommerce_demo"

constant: custom_value_format {
  value: "0.##"
}

# Period over Period


constant: default_selected_period_end {
  value: "
  date({% date_end current_date_range %})
  "
}


constant: selected_period_end {
  value: "
  {% if time_measure_selection._parameter_value == 'daterange' %}
  case
  when @{default_selected_period_end} <= CURRENT_DATE() then
  least(ifnull(date_add(date({% date_end current_date_range %}), interval -1 day),'9999-01-01'),date_add(CURRENT_DATE(), interval -1 day))
  else
  ifnull(date_add(date({% date_end current_date_range %}), interval -1 day),'9999-01-01')
  end
  {% else %}
  least(ifnull(date_add(date({% date_end current_date_range %}), interval -1 day),'9999-01-01'),date_add(CURRENT_DATE(), interval -1 day))
  {% endif %}
  "
}

#### MTD & YTD & LxM shouldn't include today

constant: selected_period_start {
  value: "
  {% if time_measure_selection._parameter_value == 'daterange' %}
  date({% date_start current_date_range %})
  {% elsif time_measure_selection._parameter_value == 'lfd' %}
  @{selected_period_end}
  {% elsif time_measure_selection._parameter_value == 'l7d' %}
  date_add(@{selected_period_end}, interval -6 day)
  {% elsif time_measure_selection._parameter_value == 'l28d' %}
  date_add(@{selected_period_end}, interval -27 day)
  {% elsif time_measure_selection._parameter_value == 'mtd' %}
  date(extract(year from @{selected_period_end}),extract(month from @{selected_period_end}),1)
  {% elsif time_measure_selection._parameter_value == 'l3m' %}
  date_add(@{selected_period_end}, interval -3 month)
  {% elsif time_measure_selection._parameter_value == 'l6m' %}
  date_add(@{selected_period_end}, interval -6 month)
  {% elsif time_measure_selection._parameter_value == 'l9m' %}
  date_add(@{selected_period_end}, interval -9 month)
  {% elsif time_measure_selection._parameter_value == 'ytd' %}
  if(extract(month from @{selected_period_end}) <= 3,date(extract(year from @{selected_period_end})-1,4,1),date(extract(year from @{selected_period_end}),4,1))
  {% elsif time_measure_selection._parameter_value == 'l12m' %}
  date_add(@{selected_period_end}, interval -1 year)
  {% elsif time_measure_selection._parameter_value == 'xkpis' %}
  date_add(@{selected_period_end}, interval -2 year)
  {% else %}
  date({% date_start current_date_range %})
  {% endif %}"
}

######## Previous Year #########

constant: last_year_period_start {
  value: "date_add(@{selected_period_start}, interval -1 year)"
}

constant: last_year_period_end {
  value: "date_add(@{selected_period_end}, interval -1 year)"
}


######### Adjusted Previous Year #########

constant: last_adjusted_year_period_start {
  value: "date_from_unix_date(unix_date(date_add(@{selected_period_start}, interval -1 year)) + mod(unix_date(date(@{selected_period_start})) - unix_date(date_add(@{selected_period_start}, interval -1 year)),7))"
}

constant: last_adjusted_year_period_end {
  value: "date_from_unix_date(unix_date(date_add(@{selected_period_end}, interval -1 year)) + mod(unix_date(date(@{selected_period_end})) - unix_date(date_add(@{selected_period_end}, interval -1 year)),7))"
}

######## Previous Period ##########

constant: last_period_period_start {
  value: "date_add(@{selected_period_start}, interval -1 * date_diff(@{selected_period_end}, @{selected_period_start}, day) day)"
}

constant: last_period_period_end {
  value: "@{selected_period_start}"
}

######## Comparison ##########

constant: last_comparison_period_start {
  value: "date({% date_start comparison_date_range %})"
}

constant: last_comparison_period_end {
  value: "date({% date_end comparison_date_range %})"
}

################################

constant: comparison_period_start {
  value: "
  {% if time_period_selection._parameter_value == 'Year' %}
  @{last_year_period_start}
  {% elsif time_period_selection._parameter_value == 'Period' %}
  @{last_period_period_start}
  {% elsif time_period_selection._parameter_value == 'Comparison' %}
  @{last_comparison_period_start}
  {% elsif time_period_selection._parameter_value == 'Adjusted_Year' %}
  @{last_adjusted_year_period_start}
  {% else %}
  @{selected_period_start}
  {% endif %}"
}

constant: comparison_period_end {
  value: "
  {% if time_period_selection._parameter_value == 'Year' %}
  @{last_year_period_end}
  {% elsif time_period_selection._parameter_value == 'Period' %}
  @{last_period_period_end}
  {% elsif time_period_selection._parameter_value == 'Comparison' %}
  @{last_comparison_period_end}
  {% elsif time_period_selection._parameter_value == 'Adjusted_Year' %}
  @{last_adjusted_year_period_end}
  {% else %}
  @{selected_period_end}
  {% endif %}"
}


constant: creation_date_selected_period_start {
  value: "date({% date_start filter_creation_date %}) "
}

constant: creation_date_selected_period_end {
  value: "date({% date_end filter_creation_date %})"
}
