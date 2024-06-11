note
	description: "Invalid payment table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-09 9:53:36 GMT (Sunday 9th June 2024)"
	revision: "7"

class
	INVALID_PAYMENT_TABLE

inherit
	DATA_TABLE [PAYPAL_PAYMENT]
		undefine
			is_equal, copy
		select
			remove, extend, replace
		end

	PAYMENT_LIST
		rename
			make as make_chain_implementation,
			remove as chain_remove,
			extend as chain_extend,
			replace as chain_replace
		undefine
			append
		end

	EL_MODULE_USER_INPUT

	SHARED_DATABASE

create
	make

feature -- Shell operations

	enter_shell_approve_transactions
		local
			shell: INVALID_PAYMENT_COMMAND_SHELL
		do
			create shell.make ("APPROVE TRANSACTIONS", agent try_approve, Current)
			shell.run_command_loop
		end

feature {NONE} -- Implementation

	try_approve (key: NATURAL; shell: INVALID_PAYMENT_COMMAND_SHELL)
		local
			l_index: INTEGER; payment: PAYPAL_PAYMENT
		do
			restrict_access
				key_index.list_search (key)
				if found then
					item.print_fields (lio)
					lio.put_new_line
					l_index := index
				else
					lio.put_line ("Payment not found")
				end
			end_restriction
			if l_index > 0 and then User_input.approved_action_y_n ("Approve transaction?") then
				restrict_access
					go_i_th (l_index)
					payment := item.twin
					delete
				end_restriction
				payment.set_valid_amount
				Database.fulfill_order (payment)
			end
		end

feature {INVALID_PAYMENT_COMMAND_SHELL} -- Factory

	new_menu_table: HASH_TABLE [ZSTRING, NATURAL]
		local
			template: ZSTRING
		do
			template := "%S: %S"
			restrict_access
				create Result.make_equal (count)
				from start until after loop
					if not item.is_deleted then
						Result.extend (template #$ [item.date_time_formatted, item.customer.name], item.key)
					end
					forth
				end
			end_restriction
		end

end