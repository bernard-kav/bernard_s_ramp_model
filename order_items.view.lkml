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

# measure: count_opened_drilled {
#   type: count_distinct
#   sql_distinct_key: ${zendesk_tickets.ticket_id} ;;
#   sql: ${ticket_id} ;;
#   drill_fields: [ticket_id, zendesk_tickets.status, zendesk_tickets.created_date, zendesk_tickets.assignee, backup_list.installation_expire_date]
#   filters: {
#     field: action
#     value: "opened"
#   }
#
#   link: {
#     label: "Detailed Analysis for \"{{backup_list.domain_name._value}}\""
#     url: "https://docebo.looker.com/embed/dashboards/275?Domain={{backup_list.domain_name._value}}&Time%20frame={{ _filters['pdt_zendesk_opened_closed_tasks.action_date'] | url_encode }}"
#   }
#
#   html: {{linked_value}} (Installation Expires on {{backup_list.installation_expire_date._value}}) ;;
# }

# measure: mrr_amount_usd {
#   type: number
#   sql: ${mrr_usd};;
#   html: ${{rendered_value}} ;;
#   value_format_name: decimal_2
# }
#
#
#
