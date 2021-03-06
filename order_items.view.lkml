view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd_0
  }


      measure: totalrevenue {
        description: "careful now"
        type: sum
        sql: ${sale_price} ;;
        required_fields: [currency]
      }


dimension: currency {
  type: string
}

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }
  measure: total_rev{
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }
}
