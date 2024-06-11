note
	description: "Customer table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-09 9:53:36 GMT (Sunday 9th June 2024)"
	revision: "18"

class
	CUSTOMER_TABLE

inherit
	DATA_TABLE [CUSTOMER]
		export
			{DATA_TABLE} mutex
		undefine
			is_equal, copy
		redefine
			delete_file, make, display
		select
			remove, extend, replace
		end

	CUSTOMER_LIST
		rename
			make as make_chain_implementation,
			remove as chain_remove,
			extend as chain_extend,
			replace as chain_replace
		undefine
			append
		redefine
			key_delete
		end

	SHARED_DATABASE

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_MODULE_DEFERRED_LOCALE; EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	make (config: DATABASE_CONFIGURATION)
		do
			make_solitary
			Precursor (config)
			if is_empty then
				extend (new_unknown)
			end
		ensure then
			has_unknown: count >= 1 and then first.name ~ Unknown_name
		end

feature -- Access

	item_by_email (email: ZSTRING): CUSTOMER
		do
			restrict_access
				email_index.search (email)
				Result := email_index.found_item
			end_restriction
		end

	name_by_key (key: NATURAL): ZSTRING
		do
			restrict_access
				key_index.search (key)
				Result := key_index.found_item.name
			end_restriction
		end

feature -- Element change

	import_item (imported: IMPORTED_CUSTOMER)
		local
			customer: CUSTOMER; template: ZSTRING; update_address: BOOLEAN
		do
			customer := item_by_email (imported.email)
			if customer.is_default then
				imported.print_fields (lio)
				if User_input.approved_action_y_n ("Add this customer") then
					update_address := not imported.address.is_empty
					extend (imported.to_customer)
				end

			elseif customer.name /~ imported.name then
				template := "[
					Change name: "#" => "#"
				]"
				if User_input.approved_action_y_n (template #$ [customer.name, imported.name]) then
					customer.name.share (imported.name)
					key_replace (customer)
				end

			elseif not customer.address.is_confirmed
				and then not imported.address.is_empty and then customer.address.differs (imported.address)
			then
				lio.put_line ("CURRENT")
				customer.address.print_fields (lio, True)
				lio.put_line ("UPDATED")
				imported.address.print_fields (lio, True)
				update_address := User_input.approved_action_y_n ("Change address")
			end
			if update_address then
				link_address (customer, imported.address)
			end
		end

	link_address (customer: CUSTOMER; address: ADDRESS)
		require
			has_customer: key_index.has_key (customer.key)
			valid_address: customer.is_linkable (address)
		do
			address.set_customer (customer)
			if address.key = 0 then
				Database.address_table.extend (address)
			else
				Database.address_table.key_replace (address)
			end
			customer.set_address (address)
			key_replace (customer)
		ensure
			linked: customer.address = address
		end

feature -- Removal

	delete_file
		do
			Precursor
			extend (new_unknown)
		end

	key_delete (key: NATURAL_32)
		local
			is_deleted: BOOLEAN
		do
			restrict_access
				key_index.list_search (key)
				if found then
					delete; is_deleted := True
				end
			end_restriction
			if is_deleted then
				Database.delete_customer_linked (key)
			else
				lio.put_labeled_string ("Customer with key", key.out); lio.put_line (" NOT FOUND")
			end
		end

feature -- Basic operations

	display
		do
			restrict_access
				if is_empty then
					lio.put_line ("Database is empty")
				else
					lio.put_new_line
					across Current as customer loop
						if not customer.item.is_deleted then
							customer.item.print_fields (lio)
							lio.put_new_line
						end
					end
				end
			end_restriction
		end

	display_selected (name_substring: ZSTRING)
		local
			lower_name_substring: ZSTRING
		do
			restrict_access
				lower_name_substring := name_substring.as_lower
				across Current as customer loop
					if not customer.item.is_deleted
						and then customer.item.name.as_lower.has_substring (lower_name_substring)
					then
						customer.item.print_fields (lio)
						lio.put_new_line
					end
				end
			end_restriction
		end

feature -- Shell commands

	display_subscriptions (customer: CUSTOMER_MANAGEMENT_SHELL)
		do
			restrict_access
				key_index.list_search (customer.key)
				if found then
					item.print_fields (lio)
					lio.put_new_line
					item.subscription_list.print_info
				else
					lio.put_line ("Customer not found")
				end
			end_restriction
		end

	forward_subscription_pack (customer: CUSTOMER_MANAGEMENT_SHELL)
		local
			subscriptions: LIST [SUBSCRIPTION]
		do
			subscriptions := item_by_key (customer.key).unassigned_subscriptions
			if subscriptions.is_empty then
				lio.put_line ("No unassigned subscriptions found")
				lio.put_new_line
			else
				across subscriptions as subscription loop
					subscription.item.print_fields (lio)
				end
				customer.selection.manager.forward (subscriptions)
			end
		end

	give_subscription (customer: CUSTOMER_MANAGEMENT_SHELL)
		local
			shell: EL_COMMAND_SHELL
		do
			create shell.make ("Subscription duration", new_subscription_table (customer), 10)
			shell.run_command_loop
		end

	give_subscription_duration (customer: CUSTOMER_MANAGEMENT_SHELL; duration: INTEGER)
		local
			language: STRING; subscription: SUBSCRIPTION
		do
			language := User_input.line ("Language (if not English)")
			language.adjust
			if language.is_empty then
				language := Locale.default_language
			end
			if Locale.has_language (language) and then attached item_by_key (customer.key) as l_customer then
				create subscription.make (l_customer, language, duration, 0)
				customer.selection.manager.import_subscription (l_customer, subscription)
				customer.selection.refresh
				lio.put_line ("DONE")
			else
				lio.put_labeled_string ("Invalid language", language)
				lio.put_new_line
			end
		end

	save_subscription_email (customer: CUSTOMER_MANAGEMENT_SHELL)
		local
			email: SUBSCRIPTION_DELIVERY_EMAIL
		do
			restrict_access
				key_index.list_search (customer.key)
				if found then
					if item.unassigned_subscriptions.is_empty then
						lio.put_line ("No unassigned subscriptions found")
					else
						create email.make (item.unassigned_subscriptions, item.email)
						email.serialize
						lio.put_path_field ("Saved", email.email_path)
						lio.put_new_line
					end
				else
					lio.put_line ("Customer not found")
				end
			end_restriction
		end

	select_subscription_to_delete (customer: CUSTOMER_MANAGEMENT_SHELL)
		local
			selected_index: INTEGER
		do
			if customer.key > 0 then
				display_subscriptions (customer)
				selected_index := User_input.integer ("Enter subscription number")
				lio.put_new_line
				if selected_index > 0 then
					lio.put_integer_field ("Delete subscription", selected_index)
					if User_input.approved_action_y_n (" Are you sure?") then
						Database.subscription_table.delete_by_customer (customer.key, selected_index)
						customer.selection.refresh
					end
				end
			end
		end

	select_subscription_to_reassign (customer: CUSTOMER_MANAGEMENT_SHELL)
			-- Reassign current subscription to a different machine id
		local
			selected_index: INTEGER; subscription: SUBSCRIPTION
			subscription_list: CUSTOMER_SUBSCRIPTION_LIST
		do
			if customer.key > 0 then
				display_subscriptions (customer)
				selected_index := User_input.integer ("Select a subscription")
				lio.put_new_line
				if selected_index > 0 then
					subscription_list := Database.subscription_table.customer_list (customer.key)
					if subscription_list.valid_index (selected_index) then
						subscription := subscription_list.i_th (selected_index)
						if subscription.is_current then
							lio.put_labeled_string ("Reassign subscription", subscription.activation_code.out)
							lio.put_new_line
							if User_input.approved_action_y_n ("Are you sure?") then
								Database.subscription_table.reassign (subscription.activation_code)
								lio.put_line ("Reassigned")
							end
						else
							lio.put_line ("Subscription is not current")
						end
					else
						lio.put_line ("Invalid selection")
					end
				end
			end
		end

	try_delete (customer: CUSTOMER_MANAGEMENT_SHELL)
		do
			display_subscriptions (customer)
			if User_input.approved_action_y_n ("Delete this customer. Are you sure?") then
				key_delete (customer.key)
				customer.force_exit
				customer.selection.refresh
			end
		end

feature {CUSTOMER_SELECTION_SHELL} -- Factory

	new_menu_table (keyword: ZSTRING): HASH_TABLE [ZSTRING, NATURAL]
		local
			template: ZSTRING
		do
			template := "%S (%S)"
			restrict_access
				create Result.make_equal (count)
				across query_if (agent not_first_or_deleted).ordered_by (agent {CUSTOMER}.email, True) as list loop
					if attached list.item as customer and then customer.name.has_substring (keyword) then
						Result.extend (template #$ [customer.name, customer.subscription_count], customer.key)
					end
				end
			end_restriction
		end

	new_subscription_table (customer: CUSTOMER_MANAGEMENT_SHELL): EL_PROCEDURE_TABLE [ZSTRING]
		local
			config: SUBSCRIPTION_CONFIGURATION
			description: ZSTRING
		do
			create config.make
			create Result.make_size (config.duration_options.count)
			across config.duration_option_table as table loop
				if table.item.is_lifetime then
					description:= "Lifetime"
				else
					create description.make_empty
					description.append_integer (table.item.duration)
					description.append_string_general (" years")
					if table.item.duration = 1 then
						description.remove_tail (1)
					end
				end
				Result [description] := agent give_subscription_duration (customer, table.item.duration)
			end
		end

feature {NONE} -- Implementation

	not_first_or_deleted (customer: CUSTOMER): BOOLEAN
		do
			if customer /= first_unknown then
				Result := not customer.is_deleted
			end
		end

end