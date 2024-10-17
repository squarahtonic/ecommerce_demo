connection: "thelook_ecommerce"

label: "E-commerce Demo"

include: "/explores/inventory_items.explore.lkml"
include: "/explores/order_items.explore.lkml"

include: "/utilities/datagroups.lkml"
include: "/utilities/data_tests.lkml"

persist_with: default

# access_grant: can_view_user_info {
#   user_attribute: department
#   allowed_values: ["Customer Support"]
# }
