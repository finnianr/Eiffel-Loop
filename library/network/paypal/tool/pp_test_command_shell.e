note
	description: "[
		Command shell that can be used for testing purposes. Use the class [$source EL_COMMAND_SHELL_APPLICATION]
		in conjunction with this class to make a sub-application. The source page has some links to examples that
		demonstrates how it's done.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 15:03:37 GMT (Tuesday 4th October 2022)"
	revision: "24"

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

	create_button
		local
			response: PP_BUTTON_QUERY_RESULTS
		do
			lio.put_line ("create_button")
			response := paypal.create_buy_now_button ("en_US", new_single_license.to_parameter_list, new_buy_options (1.0))
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
				list_buttons
			end
			lio.put_new_line
		end

	delete_button
		local
			response: PP_HTTP_RESPONSE
		do
			lio.put_line ("delete_button")
			response := paypal.delete_button (new_hosted_button)
			if response.is_ok then
				lio.put_line ("BUTTON DELETED")
				response.print_values
				list_buttons
			else
				lio.put_line ("ERROR")
			end
			lio.put_new_line
		end

	get_button_details
		local
			results: PP_BUTTON_DETAILS_QUERY_RESULTS
		do
			lio.put_line ("get_button_details")
			results := paypal.get_button_details (new_hosted_button)
			if results.is_ok then
				lio.put_line ("BUTTON DETAILS")
				results.print_values
			else
				lio.put_line ("ERROR")
			end
			lio.put_new_line
		end

	list_buttons
		local
			search_results: like paypal.button_search_results
		do
			lio.put_line ("list_buttons")
			lio.put_line ("ID list")
			search_results := paypal.button_search_results
			if search_results.is_ok then
				across search_results.button_list as button loop
					lio.put_labeled_string (button.cursor_index.out, button.item.l_hosted_button_id)
					lio.put_new_line
				end
				lio.put_new_line
			else
				lio.put_line ("ERROR")
			end
			lio.put_new_line
		end

	run_command_loop
		do
			Precursor
			paypal.close
		end

	update_button
		local
			response: PP_BUTTON_QUERY_RESULTS
		do
			lio.put_line ("update_button")
			response := paypal.update_buy_now_button (
				"en_US", new_hosted_button, new_single_license.to_parameter_list, new_buy_options (1.1)
			)
			response.print_values
			lio.put_new_line
		end

feature {NONE} -- Implementation

	new_buy_options (price_factor: REAL): PP_BUY_OPTIONS
		do
			create Result.make (0, "Duration", currency_code)
			Result.extend ("1 year", (290 * price_factor).rounded)
			Result.extend ("2 years", (530 * price_factor).rounded)
			Result.extend ("5 years", (1200 * price_factor).rounded)
		end

	new_command_table: like command_table
		do
			create Result.make (<<
				["Create a test subscription 'buy now' button", agent create_button],
				["List all buttons", agent list_buttons],
				["Get button details", agent get_button_details],
				["Delete button", agent delete_button],
				["Delete all buttons", agent delete_all_buttons],
				["Update button with 10%% price increase", agent update_button]
			>>)
		end

	new_hosted_button: PP_HOSTED_BUTTON
		do
			create Result.make (User_input.line ("Enter button code"))
			lio.put_new_line
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

feature {NONE} -- Constants

	Cert_authority_info_path: FILE_PATH
		once
			Result := Directory.Home + "Documents/Certificates/cacert.pem"
		end

end