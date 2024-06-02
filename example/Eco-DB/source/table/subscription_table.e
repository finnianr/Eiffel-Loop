note
	description: "Subscription table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at hex11software dot com"

	license: "All rights reserved"
	date: "2022-02-02 13:07:47 GMT (Wednesday 2nd February 2022)"
	revision: "8"

class
	SUBSCRIPTION_TABLE

inherit
	DATA_TABLE [SUBSCRIPTION]
		rename
			item as subscription_item
		undefine
			is_equal, copy
		select
			remove, extend, replace
		end

	SUBSCRIPTION_LIST
		rename
			make as make_chain_implementation,
			remove as chain_remove,
			extend as chain_extend,
			replace as chain_replace
		undefine
			append
		end

create
	make

feature -- Access

	customer_list (customer_key: NATURAL): CUSTOMER_SUBSCRIPTION_LIST
		do
			restrict_access
				customer_group_table.search (customer_key)
				create Result.make_from_array (customer_group_table.found_list.to_array)
			end_restriction
		end

	count_with (customer: CUSTOMER): INTEGER
		do
			restrict_access
				customer_group_table.search (customer.key)
				Result := customer_group_table.found_list.count
			end_restriction
		end

	customer_with_machine_id (machine_id: STRING): CUSTOMER
		do
			restrict_access
				machine_id_index.search (machine_id)
				if machine_id_index.found then
					Result := machine_id_index.found_item.customer
				else
					create Result.make_default
				end
			end_restriction
		end

feature -- Element change

	reassign (activation_code: EL_UUID)
		do
			restrict_access
				activation_code_index.list_search (activation_code)
				if found and then subscription_item.is_assigned then
					subscription_item.deactivate
					replace (subscription_item)
				end
			end_restriction
		end

feature -- Removal

	delete_by_customer (customer_key: NATURAL; a_index: INTEGER)
		local
			group_list: LIST [SUBSCRIPTION]
		do
			restrict_access
				if customer_group_table.has_key (customer_key) then
					group_list := customer_group_table.found_list
					if group_list.valid_index (a_index) then
						activation_code_index.list_search (group_list.i_th (a_index).activation_code)
						if found and then not subscription_item.is_deleted then
							delete
						end
					end
				end
			end_restriction
		end

end