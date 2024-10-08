note
	description: "[
		Command shell that can be used for testing purposes. Use the class ${EL_COMMAND_SHELL_APPLICATION}
		in conjunction with this class to make a sub-application. The source page has some links to examples that
		demonstrates how it's done.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 17:50:53 GMT (Sunday 22nd September 2024)"
	revision: "33"

class
	PP_TEST_COMMAND_SHELL

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		redefine
			run_command_loop
		end

	EL_MODULE_DIRECTORY; EL_MODULE_USER_INPUT

	EL_CURRENCY_PROPERTY

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH; encrypter: EL_AES_ENCRYPTER)
		local
			config: PP_CONFIGURATION
		do
			make_shell ("Paypal Buttons", 10)

			create config.make (config_path, encrypter)

			create paypal.make (config)
			paypal.open
			currency_code := Currency_enum.HUF
		end

feature -- Constants

	Description: STRING = "Menu driven Paypal test tool"

feature -- Basic operations

	run_command_loop
		do
			Precursor
			paypal.close
		end

feature {NONE} -- Commands

	create_button
		local
			response: PP_BUTTON_QUERY_RESULTS
		do
			lio.put_line ("create_button")
			response := paypal.create_buy_now_button ("en_US", new_single_license.to_parameter_list, new_buy_options)
			response.print_values
			lio.put_new_line
		end

	delete_all_buttons
		local
			response: PP_HTTP_RESPONSE; failed: BOOLEAN
		do
			lio.put_line ("delete_all_buttons")
			across paypal.button_search_results.button_list as button until failed loop
				lio.put_labeled_string ("Deleting button", button.item.l_hosted_button_id)
				lio.put_new_line
				response := paypal.delete_button (button.item.hosted_button)
				failed := not response.is_ok
			end
			if failed then
				lio.put_line ("ERROR")
			else
				lio.put_line ("ALL BUTTONS DELETED")
			end
			lio.put_new_line
		end

	delete_button
		local
			button_id: ZSTRING; hosted_button: PP_HOSTED_BUTTON
		do
			button_id := User_input.line ("Enter button code")
			lio.put_new_line
			if not User_input.escape_pressed then
				lio.put_line ("delete_button")
				create hosted_button.make (button_id)
				if attached paypal.delete_button (hosted_button) as response and then response.is_ok then
					lio.put_line ("BUTTON DELETED")
					response.print_values
				else
					lio.put_line ("ERROR")
				end
				lio.put_new_line
			end
		end

	display_button_menu
		local
			button_table: EL_PROCEDURE_TABLE [ZSTRING]; sub_menu: EL_COMMAND_SHELL
		do

			if attached paypal.button_search_results as search_results and then search_results.is_ok
				and then attached search_results.button_list as button_list
			then
				create button_table.make (button_list.count)
				across button_list as list loop
					if attached list.item as button then
						button_table.extend (agent get_button_details (button), button.l_hosted_button_id)
					end
				end
				create sub_menu.make ("GET BUTTON DETAILS", button_table, 10)
				sub_menu.run_command_loop
			else
				lio.put_line ("ERROR in search results")
			end
		end

feature {NONE} -- Implementation

	get_button_details (meta_data: PP_BUTTON_META_DATA)
		do
			lio.put_line ("Getting button details " + meta_data.l_hosted_button_id)
			if attached paypal.get_button_details (meta_data) as results then
				lio.put_new_line
				if results.is_ok then
					results.print_values
				else
					results.print_errors
				end
			end
			lio.put_new_line
		end

feature {NONE} -- Factory

	new_buy_options: PP_BUY_OPTIONS
		local
			price_x_100_table: EL_HASH_TABLE [INTEGER, STRING]
		do
			create price_x_100_table.make_assignments (<<
				["1 year", 290], ["2 year", 530], ["5 year", 1200], ["Lifetime", 48000]
			>>)
			create Result.make (0, "Duration", currency_code)
			across price_x_100_table as table loop
				Result.extend (table.key, table.item)
			end
		end

	new_command_table: like command_table
		do
			create Result.make_assignments (<<
				["Create a test subscription 'buy now' button",	agent create_button],
				["Button details menu",									agent display_button_menu],
				["Delete button",											agent delete_button],
				["Delete all buttons",									agent delete_all_buttons]
			>>)
		end

	new_single_license: PP_PRODUCT_INFO
		do
			create Result.make
			Result.set_currency_code (currency_code)
			Result.set_item_name ("Single PC subscription pack")
			Result.set_item_number ("1.en." + currency_code_name)
		end

feature {NONE} -- Internal attributes

	paypal: PP_NVP_API_CONNECTION

end