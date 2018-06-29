view: orders {
  sql_table_name: demo_db.orders ;;

  filter: timeframes {
    type: date_time
  }

  dimension: start {
    type: date
    sql: {% date_start date_filter %} ;;
  }
  dimension: end {
    type: date
    sql: {% date_end date_filter %};;
  }
  dimension: final {
    type: string
    sql: 'from ' ||${start} || ' to ' || ${end} ;;
  }
  dimension: test {
    type: string
  }
  dimension: test1 {
    type: string
  }

  filter: date_filter {
    type: date
  }

  dimension_group: filter_start_date {
    type: time
    timeframes: [raw]
    sql: CASE WHEN {% date_start timeframes %} IS NULL THEN '1970-01-01' ELSE  TIMESTAMP(NULLIF({% date_start timeframes %}, 0)) END;;
  }
  dimension_group: filter_end_date {
    type: time
    timeframes: [raw]
    #sql: CASE WHEN {% date_end ${timeframes} %} IS NULL THEN CURRENT_DATE ELSE NULLIF({% date_end ${timeframes} %}, 0)::timestamp END;;
    sql: CASE WHEN {% date_end timeframes %} IS NULL THEN NOW() ELSE TIMESTAMP(NULLIF({% date_end timeframes %}, 0)) END;;
  }
  dimension: interval {
    type: number
    sql: TIMESTAMPDIFF(second, ${filter_end_date_raw}, ${filter_start_date_raw});;
  }
  dimension: previous_start_date {
    type: date
    sql: DATE_ADD(${filter_start_date_raw}, interval ${interval} second) ;;
  }

  dimension: timeframes_filter {
    # description: "Use this field in combination with the date filter field for dynamic date filtering”
    suggestions: ["period","previous period"]
    type: string
    case:  {
      when:  {
        sql: ${created_raw} BETWEEN ${filter_start_date_raw} AND  ${filter_end_date_raw};;
        label: "Current Period"
      }
      when: {
        sql: ${created_raw} BETWEEN ${previous_start_date} AND ${filter_start_date_raw} ;;
        label: "Previous Period"
      }
      else: "Not in time period"
    }
  }



  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      time_of_day,
      hour_of_day,
      day_of_week_index,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: day_of_week_short {
    label: "day of week"
    type: string
    sql:
      CASE
        WHEN ${created_day_of_week_index} = 0 THEN 'Mon'
        WHEN ${created_day_of_week_index} = 1 THEN 'Tue'
        WHEN ${created_day_of_week_index} = 2 THEN 'Wed'
        WHEN ${created_day_of_week_index} = 3 THEN 'Thu'
        WHEN ${created_day_of_week_index} = 4 THEN 'Fri'
        WHEN ${created_day_of_week_index} = 5 THEN 'Sat'
        WHEN ${created_day_of_week_index} = 6 THEN 'Sun'
        ELSE ''
      END;;
  }

  dimension: date_day_concat {
    type: string
    sql: CONCAT(${created_date}, " ",${day_of_week_short}) ;;
  }

  measure: first_order {
    type: date
    sql: MIN(${created_date}) ;;
  }

  measure: last_order {
    type: date
    sql: MAX(${created_date}) ;;
  }

  dimension: created_formatted_date {
    group_label: "created"
    sql: ${TABLE}.created_at ;; # whatever formatting here in SQL
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: my_measure {
    type: number
    sql: IFNULL(${count}, 0) ;;
  }

  measure: count {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]

  link: {
    label: "Detailed Analysis for \"{{users.email._value}}\""
    url: "https://docebo.looker.com/embed/dashboards/275?Domain={{users.email._value}}"
  }
 }
measure: test_2 {
  type: count_distinct
  sql: ${user_id};;
}

}
