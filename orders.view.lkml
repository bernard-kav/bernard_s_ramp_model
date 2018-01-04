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
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
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

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }
}
