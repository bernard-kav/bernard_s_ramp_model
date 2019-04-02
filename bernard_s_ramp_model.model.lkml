connection: "thelook"

# include all the views
include: "*.view"

explore: events {
  join: users {
    view_label: "Events"
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

# explore: inventory_items {
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }
# }

explore: order_items {
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: products {}

explore: schema_migrations {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {}

explore: order_purchase_affinity {
  label: "Affinity"
  view_label: "Affinity"

  always_filter: {
    filters: {
      field: affinity_timeframe
      value: "last 90 days"
    }
  }

  join: total_orders {
    type: cross
    relationship: many_to_one
  }
}
