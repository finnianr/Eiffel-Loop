note
	description: "Management command shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-03 13:37:24 GMT (Wednesday 3rd April 2024)"
	revision: "32"

class
	DATABASE_MANAGER_SHELL

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell,
			on_user_quit as on_shutdown
		redefine
			execute, make_table, on_shutdown
		end

	DURATION_CONSTANTS

	EL_MODULE_DEFERRED_LOCALE; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE

	EL_MODULE_LOG_MANAGER; EL_MODULE_DIRECTORY; EL_MODULE_OS; EL_MODULE_USER_INPUT

	SHARED_CUSTOMER_TABLE; SHARED_DATABASE_CONFIGURATION; SHARED_HOST

	EL_SHARED_SINGLETONS

feature {EL_COMMAND_CLIENT} -- Initialization

	make
		do
			make_shell ("DATABASE", 10)
		end

	make_table
		do
			create database.make_open (Database_config)
			Precursor
		end

feature -- Constants

	description: STRING
		do
			Result := "Menu driven database management shell"
		end

feature -- Basic operations

	execute
		do
			prepare_execution
			if is_prepared then
				run_command_loop
			else
				lio.put_line ("Execution not prepared")
				User_input.press_enter
			end
		end

	forward (subscriptions: LIST [SUBSCRIPTION])
		do
			lio.put_line ("No email service")
		end

	import_subscription (customer: CUSTOMER; subscription: SUBSCRIPTION)
		local
			new_subscriptions: CUSTOMER_SUBSCRIPTION_LIST
		do
			lio.put_line ("send_subscription")
			create new_subscriptions.make (customer, "en", subscription.duration, 1, 0)
			Database.subscription_table.append (new_subscriptions)
			send_subscription (customer, new_subscriptions)
		end

	on_shutdown
		do
			database.close
		end

feature -- Status query

	is_prepared: BOOLEAN
		-- `True' if prepared to `run_command_loop'

feature {NONE} -- Command menu

	delete_database
		do
			if User_input.approved_action_y_n ("Deleting database. Are you sure?") then
				database.delete
				lio.put_line ("Deleted!")
			end
		end

	import_customer_data
		local
			customer_list: IMPORTED_CUSTOMER_LIST
		do
			create customer_list.make
			across customer_list as list loop
				Customer_table.import_item (list.item)
			end
		end

	manage_customers
		local
			shell: CUSTOMER_SELECTION_SHELL
		do
			if attached User_input.line ("Keyword") as keyword then
				keyword.adjust
				lio.put_new_line
				create shell.make (Current, keyword)
				if shell.option_count > 0 then
					shell.run_command_loop
				else
					lio.put_string_field ("No matches found for", keyword)
					lio.put_new_line_x2
				end
			end
		end

feature {NONE} -- Factory

	new_command_table: EL_PROCEDURE_TABLE [ZSTRING]
		local
			shell: EL_COMMAND_SHELL; name: STRING
		do
			create Result.make (<<
				["Approve failed payments",	agent do database.invalid_payment_table.enter_shell_approve_transactions end],
				["Create versioned backup",	agent do database.backup end],

				["Delete database", 			   agent delete_database],

				["List customers", 				agent do database.customer_table.display end],
				["List feature requests", 		agent do database.feature_request_table.display end],
				["List payments",					agent do database.payment_table.display end],

				["Manage customer",				agent manage_customers]
			>>)
			if attached new_service_command_table as service_table and then service_table.count > 0 then
				Result.merge (service_table)
			end
			name := "IMPORT/EXPORT"
			create shell.make (name, new_import_export_command_table, 10)
				Result [name] := agent shell.run_command_loop

			if attached new_extra_command_table as extra_table and then extra_table.count > 0 then
				name := "EXTRAS"
				create shell.make (name, extra_table, 10)
				Result [name] := agent shell.run_command_loop
			end
		end

	new_extra_command_table: EL_PROCEDURE_TABLE [ZSTRING]
		do
			create Result
		end

	new_import_export_command_table: EL_PROCEDURE_TABLE [ZSTRING]
		do
			create Result.make (<<
				["Export tables meta data",	agent do database.export_meta_data end],
				["Export tables as CSV",		agent do database.export_as_csv end],
				["Export tables as Pyxis",		agent do database.export_as_pyxis end],

				["Import CSV data",				agent do database.import_csv end],
				["Import Pyxis data",			agent do database.import_pyxis end],
				["Import customer data",		agent import_customer_data]
			>>)
		end

	new_service_command_table: EL_PROCEDURE_TABLE [ZSTRING]
		do
			create Result
		end

feature {NONE} -- Implementation

	call (object: ANY)
		do
		end

	prepare_execution
		do
			is_prepared := True
		end

	send_subscription (customer: CUSTOMER; new_subscriptions: CUSTOMER_SUBSCRIPTION_LIST)
		-- send imported subscription
		do
			-- implemented in services shell
			across new_subscriptions as subscription loop
				subscription.item.print_fields (lio)
				lio.put_new_line
			end
		end

feature {EL_APPLICATION} -- Internal attributes

	database: DATABASE

end