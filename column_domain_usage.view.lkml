view: column_domain_usage {
  sql_table_name: information_schema.column_domain_usage ;;

  dimension: column_name {
    type: string
    sql: ${TABLE}.column_name ;;
  }

  dimension: domain_catalog {
    type: string
    sql: ${TABLE}.domain_catalog ;;
  }

  dimension: domain_name {
    type: string
    sql: ${TABLE}.domain_name ;;
  }

  dimension: domain_schema {
    type: string
    sql: ${TABLE}.domain_schema ;;
  }

  dimension: table_catalog {
    type: string
    sql: ${TABLE}.table_catalog ;;
  }

  dimension: table_name {
    type: string
    sql: ${TABLE}.table_name ;;
  }

  dimension: table_schema {
    type: string
    sql: ${TABLE}.table_schema ;;
  }

  measure: count {
    type: count
    drill_fields: [column_name, table_name, domain_name]
  }
}
