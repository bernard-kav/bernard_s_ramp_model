view: user_facts_pdt {
  derived_table: {
    sql:
      SELECT
        customer_id, created_date.month,
        MIN(orders.created_date) AS first_order_date,
        MAX(orders.created_date) AS latest_order_date,
        COUNT(orders.ID) AS total_orders
        DATEDIFF(first_order_date, CURDATE()) AS days_since_first_order,
        FROM user
        LEFT JOIN orders ON users.id = orders.customed_id
        GROUP BY customer_id;;
  }
  dimension: customer_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension: created_date_month {
    type: date_fiscal_month_num
    sql: ${TABLE}.created_date_month ;;
  }

  dimension: first_order_date {
    type: date
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: latest_order_date {
    type: date
    sql: ${TABLE}.latest_order_date ;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  dimension: days_since_first_order{
    type: number
    sql: ${TABLE}.days_since_first_order ;;
  }

  measure: repeat_customer {
    type: yesno
    sql: ${days_since_first_order}>1 ;;
  }

  measure: average_orders_per_month {
    type: average
    sql: ${total_orders}/${created_date_month} ;;
  }
}
