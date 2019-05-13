view: column_privileges {
  sql_table_name: information_schema.column_privileges ;;

  dimension: column_name {
    type: string
    sql: ${TABLE}.column_name ;;
  }

  dimension: grantee {
    type: string
    sql: ${TABLE}.grantee ;;
  }

  dimension: grantor {
    type: string
    sql: ${TABLE}.grantor ;;
  }

  dimension: is_grantable {
    type: string
    sql: ${TABLE}.is_grantable ;;
  }

  dimension: privilege_type {
    type: string
    sql: ${TABLE}.privilege_type ;;
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
    drill_fields: [column_name, table_name]
  }
}
