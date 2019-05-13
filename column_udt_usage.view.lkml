view: column_udt_usage {
  sql_table_name: information_schema.column_udt_usage ;;

  dimension: column_name {
    type: string
    sql: ${TABLE}.column_name ;;
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

  dimension: udt_catalog {
    type: string
    sql: ${TABLE}.udt_catalog ;;
  }

  dimension: udt_name {
    type: string
    sql: ${TABLE}.udt_name ;;
  }

  dimension: udt_schema {
    type: string
    sql: ${TABLE}.udt_schema ;;
  }

  measure: count {
    type: count
    drill_fields: [column_name, table_name, udt_name]
  }
}
