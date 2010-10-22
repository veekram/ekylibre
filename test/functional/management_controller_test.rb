require 'test_helper'

class ManagementControllerTest < ActionController::TestCase
  fixtures :companies, :users
  test_all_actions(
                   :deposit_create=>{:mode_id=>1}, 
                   :incoming_payment_mode_reflect=>:delete,
                   :incoming_payment_use_create=>{:expense_type=>"sales_order", :expense_id=>1},
                   :inventory_reflect=>:delete, 
                   :outgoing_delivery_create=>{:sales_order_id=>3},
                   :outgoing_delivery_update=>{:id=>1},
                   :incoming_delivery_create=>{:purchase_order_id=>3},
                   :incoming_delivery_update=>{:id=>1},
                   :outgoing_payment_use_create=>{:expense_id=>1},
                   :product_component_create=>{:product_id=>1}, 
                   :purchase_order_confirm=>:delete,
                   :purchase_order_invoice=>:delete,
                   :purchase_order_abort=>:delete,
                   :purchase_order_correct=>:delete,
                   :purchase_order_propose=>:delete,
                   :purchase_order_refuse=>:delete,
                   :purchase_order_finish=>:delete,
                   :purchase_order_line_create=>{:order_id=>1},
                   :sales_invoice_cancel=>:update, 
                   :sales_order_confirm=>:delete,
                   :sales_order_invoice=>:delete,
                   :sales_order_abort=>:delete,
                   :sales_order_correct=>:delete,
                   :sales_order_propose=>:delete,
                   :sales_order_refuse=>:delete,
                   :sales_order_finish=>:delete,
                   :sales_order_line_create=>{:order_id=>1},
                   :subscription_nature_increment=>:delete,
                   :subscription_nature_decrement=>:delete, 
                   :transport_deliveries=>:select, 
                   :except=>[:change_quantities, 
                             :price_find, 
                             :unpaid_sales_orders_export,
                             :subscription_coordinates,
                             :subscription_find, 
                             :subscription_message, 
                             :subscription_nature, 
                             :subscription_options, 
                             :subscriptions_period, 
                             :sales_order_line_informations,
                             :sales_order_line_detail,
                             :sales_order_line_stocks,
                             :sales_order_line_tracking,
                             :sales_order_contacts, 
                             :product_trackings, 
                             :sum_calculate,
                             :prices_export,
                             :product_units]
                   )
end
