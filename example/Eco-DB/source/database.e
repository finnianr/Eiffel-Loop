note
	description: "Subscription database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at hex11software dot com"

	license: "All rights reserved"
	date: "2023-12-06 21:13:03 GMT (Wednesday 6th December 2023)"
	revision: "21"

class
	DATABASE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_table_field,
			foreign_naming as eiffel_naming
		redefine
			initialize_fields
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_MODULE_FILE_SYSTEM

	SHARED_HOST; SHARED_EMAIL_QUEUE

create
	make_open

feature {NONE} -- Initialization

	initialize_fields
		do
			create address_table.make (config)
			create customer_table.make (config)

			create subscription_table.make (config)
			create invalid_payment_table.make (config)
			create feature_request_table.make (config)
			create payment_table.make (config)
			create prompts_suppressed
		end

	make_open (a_config: DATABASE_CONFIGURATION)
		require
			authenticated: a_config.is_logged_in
		local
			subscription: SUBSCRIPTION_CONFIGURATION
		do
			make_solitary
			config := a_config
			create subscription.make -- needed to make default instance of PAYPAL_PAYMENT
			make_default
		end

feature -- Access

	config: DATABASE_CONFIGURATION

	crc_32_digest_table: HASH_TABLE [NATURAL, ZSTRING]
		do
			create Result.make (table_list.count)
			across table_list as list loop
				Result [list.item.name] := list.item.crc_32_digest
			end
		end

	table_list: ARRAYED_LIST [DATA_TABLE [REFLECTIVELY_STORABLE]]
		do
			create Result.make (field_table.count)
			across field_table as field loop
				if attached {like table_list.item} field.item.value (Current) as table then
					Result.extend (table)
				end
			end
		end

feature -- Status query

	prompts_suppressed: EL_BOOLEAN_OPTION

feature -- Tables

	address_table: ADDRESS_TABLE

	customer_table: CUSTOMER_TABLE

	feature_request_table: FEATURE_REQUEST_TABLE

	invalid_payment_table: INVALID_PAYMENT_TABLE

	payment_table: PAYMENT_TABLE

	subscription_table: SUBSCRIPTION_TABLE

feature -- Basic operations

	backup
		local
			tar_path: FILE_PATH
		do
			if attached Tar_directory_command as cmd then
				cmd.set_working_directory (Directory.app_data)
				tar_path := config.backup_version_01_path.next_version_path

				File_system.make_directory (tar_path.parent)

				export_as_pyxis

				cmd.set_archive_path (tar_path)
				cmd.set_target_dir ("pyxis")
				cmd.execute
			end
			lio.put_path_field ("Created", tar_path)
			lio.put_new_line
			config.ftp_mirror.transfer (tar_path.parent)
		end

	close
		do
			do_with_tables ("Closing", agent {like table_list.item}.close)
		end

	delete
		do
			do_with_tables ("Deleting", agent {like table_list.item}.close_and_delete)
		end

	delete_customer_linked (key: NATURAL_32)
		do
			do_with_tables ("Deleting linked", agent {like table_list.item}.delete_customer_linked (key))
		end

	fulfill_order (payment: PAYPAL_PAYMENT)

		local
			new_subscriptions: CUSTOMER_SUBSCRIPTION_LIST; delivery_email: SUBSCRIPTION_DELIVERY_EMAIL
		do
			payment_table.extend (payment)
			create new_subscriptions.make_from_payment (payment)
			subscription_table.append (new_subscriptions)
			if new_subscriptions.is_empty then
				lio.put_line ("No subscriptions sent")
			else
				create delivery_email.make (new_subscriptions, "")
				Email_queue.put (delivery_email)
				lio.put_line ("Subscription pack sent")
			end
		end

	try_fulfill_order (payment: PAYPAL_PAYMENT)
		do
			if payment.is_valid then
				fulfill_order (payment)
			else
				invalid_payment_table.extend (payment)
				Email_queue.put_failed (payment)
			end
		end

feature -- Factory

	new_address_table: ADDRESS_TABLE
		do
			create Result.make (config)
		end

	new_customer_table: CUSTOMER_TABLE
		do
			create Result.make (config)
		end

feature -- Import/Export operations

	export_as_csv
		do
			export_data (agent {like table_list.item}.csv_file_path, agent {like table_list.item}.store_as_csv)
		end

	export_as_pyxis
		do
			export_data (agent {like table_list.item}.pyxis_file_path, agent {like table_list.item}.store_as_pyxis)
		end

	export_meta_data
		do
			export_data (agent {like table_list.item}.meta_data_file_path, agent {like table_list.item}.store_meta_data)
		end

	import_csv
		do
			import_data (agent {like table_list.item}.csv_file_path, agent {like table_list.item}.import_from_csv)
		end

	import_pyxis
		do
			import_data (agent {like table_list.item}.pyxis_file_path, agent {like table_list.item}.import_from_pyxis)
		end

feature -- Status query

	has_customer (email: ZSTRING): BOOLEAN
		do
			Result := not customer_table.item_by_email (email).is_default
		end

feature {CUSTOMER_TABLE} -- Implementation

	do_with_tables (name: STRING; action: PROCEDURE [like table_list.item])
		do
			across table_list as table loop
				lio.put_labeled_string (name, table.item.name)
				lio.put_new_line
				action (table.item)
			end
		end

feature {NONE} -- Implementation

	enter_select_table_shell (name: ZSTRING; command_table: EL_PROCEDURE_TABLE [ZSTRING])
		local
			shell: EL_COMMAND_SHELL
		do
			create shell.make (name, command_table, 10)
			shell.run_command_loop
		end

	export_data (export_path: FUNCTION [like table_list.item, FILE_PATH]; export_store: PROCEDURE [like table_list.item])
		do
			across table_list as table loop
				lio.put_labeled_string ("Writing", export_path (table.item).base)
				lio.put_new_line
				export_store (table.item)
			end
		end

	import_data (import_path: FUNCTION [like table_list.item, FILE_PATH]; import_to: PROCEDURE [like table_list.item])
		local
			timer: EL_EXECUTION_TIMER
		do
			if prompts_suppressed.is_enabled
				or else User_input.approved_action_y_n ("Replace all existing data. Are you sure?")
			then
				create timer.make
				timer.start
				across table_list as table loop
					lio.put_labeled_string ("Importing from", import_path (table.item).base)
					lio.put_new_line
					import_to (table.item)
				end
				lio.put_labeled_string ("Elapsed time", timer.elapsed_time.out)
				lio.put_new_line
			end
		end

	is_table_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.is_reference and then field.conforms_to (Table_type_id)
		end

feature {NONE} -- Constants

	Table_type_id: INTEGER
		once
			Result := ({DATA_TABLE [REFLECTIVELY_STORABLE]}).type_id
		end

	Tar_directory_command: EL_CREATE_TAR_COMMAND
		once
			create Result.make
		end

end
