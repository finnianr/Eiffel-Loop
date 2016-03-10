note
	description: "Command shell for testing purposes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 16:31:36 GMT (Sunday 20th December 2015)"
	revision: "6"

class
	EL_PAYPAL_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_COMMAND
		redefine
			run_command_loop
		end

create
	default_create

feature {EL_COMMAND_CLIENT} -- Initialization

	make (credentials_path: EL_FILE_PATH; phrase: ZSTRING)
		local
			credentials: EL_PAYPAL_CREDENTIALS
			pass_phrase: EL_PASS_PHRASE
		do
			make_shell
			create pass_phrase.make_default
			if phrase.is_empty then
				pass_phrase.ask_user
			else
				pass_phrase.set_string (phrase)
				pass_phrase.validate
			end
			create credentials.make (credentials_path, pass_phrase.new_aes_encrypter (128))
			create paypal.make ("WJA4MQCSCZHXJ", credentials, 95.0, True)
			paypal.set_notify_url ("http://sandbox.myching.software/IPN/listener")
			paypal.open
			currency_code := Hungarian_code
		end

feature -- Basic operations

	create_button
		do
			log.enter ("create_button")
			paypal.create_buy_now_button ("en_US", new_single_license_button, new_buy_options (1.0))
			paypal.log_response_values
			log.exit
		end

	delete_all_buttons
		do
			log.enter ("delete_all_buttons")
			across paypal.button_id_list as id loop
				log.put_labeled_string ("Deleting button", id.item)
				log.put_new_line
				paypal.delete_button (id.item)
			end
			if paypal.last_call_succeeded then
				log.put_line ("ALL BUTTONS DELETED")
				list_buttons
			else
				log.put_line ("ERROR")
			end
			log.exit
		end

	delete_button
		do
			log.enter ("delete_button")
			paypal.delete_button (new_button_id)
			if paypal.last_call_succeeded then
				log.put_line ("BUTTON DELETED")
				paypal.log_response_values
				list_buttons
			else
				log.put_line ("ERROR")
			end
			log.exit
		end

	get_button_details
		do
			log.enter ("get_button_details")
			paypal.get_button_details (new_button_id)
			if paypal.last_call_succeeded then
				log.put_line ("BUTTON DETAILS")
				paypal.log_response_values
			else
				log.put_line ("ERROR")
			end
			log.exit
		end

	list_buttons
		do
			log.enter ("list_buttons")
			log.put_line ("ID list")
			across paypal.button_id_list as id loop
				log.put_labeled_string (id.cursor_index.out, id.item)
				log.put_new_line
			end
			if paypal.last_call_succeeded then
				log.put_new_line
				paypal.log_response_values
			else
				log.put_line ("ERROR")
			end
			log.exit
		end

	run_command_loop
		do
			Precursor
			paypal.close
		end

	update_button
		do
			log.enter ("update_button")
			paypal.update_buy_now_button ("en_US", new_button_id, new_single_license_button, new_buy_options (1.1))
			paypal.log_response_values
			log.exit
		end

feature {NONE} -- Implementation

	new_button_id: ZSTRING
		do
			Result := User_input.line ("Enter button code")
			log.put_new_line
		end

	new_buy_options (price_factor: REAL): EL_PAYPAL_BUY_OPTIONS
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

	new_single_license_button: EL_PAYPAL_BUTTON_SUB_PARAMETER_LIST
		do
			create Result.make
			Result.set_currency_code (currency_code)
			Result.set_item_name ("Single PC subscription pack")
			Result.set_item_product_code ("1.en." + currency_code)
		end

	paypal: EL_PAYPAL_CONNECTION

	currency_code: STRING

feature {NONE} -- Constants

	Euro_code: STRING = "EUR"

	Hungarian_code: STRING = "HUF"

end
