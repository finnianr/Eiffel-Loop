note
	description: "Summary description for {EL_PAYPAL_CONNECTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 17:10:09 GMT (Sunday 20th December 2015)"
	revision: "6"

class
	EL_PAYPAL_CONNECTION

inherit
	EL_HTTP_CONNECTION
		rename
			make as make_connection,
			open as open_url
		export
			{NONE} open_url
		end

	EL_SHARED_PAYPAL_VARIABLES

create
	make

feature {NONE} -- Initialization

	make (a_account_id: like account_id; a_credentials: like credentials; a_api_version: REAL; a_is_sandbox: like is_sandbox)
		local
			version: ZSTRING
		do
			account_id := a_account_id; credentials := a_credentials
			create api_version.make (Variable.version, a_api_version.out)
			is_sandbox := a_is_sandbox
			version := api_version.value
			if not version.has ('.') then
				version.append_string_general (".0")
			end
			make_connection
			create response_values.make_equal (3)
			create notify_url.make_empty
		end

feature -- Access

	account_id: STRING

	notify_url: STRING
		-- The URL to which PayPal posts information about the payment,
		-- in the form of Instant Payment Notification messages.

	response_values: EL_PAYPAL_RESPONSE_HASH_TABLE

feature -- Element change

	set_notify_url (a_notify_url: like notify_url)
		do
			notify_url := a_notify_url
		end

feature -- Button management

	button_id_list: ARRAYED_LIST [ZSTRING]
			-- list all buttons since year 2000
		local
			variable_names: EL_ARRAYED_LIST [ZSTRING]; button_id_variable_names: ARRAYED_LIST [ZSTRING]
			start_date, end_date: EL_PAYPAL_DATE_TIME_PARAMETER
		do
			log.enter ("button_id_list")
			create start_date.make (Parameter.start_date, create {DATE_TIME}.make (2000, 1, 1, 0, 0, 0))
			create end_date.make (Parameter.end_date, create {DATE_TIME}.make_now_utc)

			call_method (Method.button_search, << start_date, end_date >>)

			if last_call_succeeded then
				create variable_names.make_from_array (response_values.current_keys)
				button_id_variable_names := variable_names.search_results (True, agent {ZSTRING}.starts_with (Button_id_name_prefix))
				create Result.make (button_id_variable_names.count)
				across button_id_variable_names as name loop
					Result.extend (response_values.item (name.item))
				end
			else
				create Result.make (0)
			end
			log.exit
		end

	create_buy_now_button (
		locale_code: STRING; button_params: EL_PAYPAL_BUTTON_SUB_PARAMETER_LIST; buy_options: EL_PAYPAL_BUY_OPTIONS
	)
		do
			log.enter ("create_buy_now_button")
			call_method (Method.create_button, <<
				new_button_locale (locale_code),
				Parameter.hosted_button_code, Parameter.buy_now_button_type, button_params, buy_options
			>>)
			log.exit
		end

	delete_button (id: ZSTRING)
		do
			log.enter ("delete_button")
			call_method (Method.manage_button_status, << new_hosted_button_id_param (id), Parameter.button_status_delete >>)
			log.exit
		end

	get_button_details (id: ZSTRING)
		do
			log.enter ("get_button_details")
			call_method (Method.get_button_details, << new_hosted_button_id_param (id) >>)
			log.exit
		end

	update_buy_now_button (
		locale_code: STRING; id: ZSTRING
		button_params: EL_PAYPAL_BUTTON_SUB_PARAMETER_LIST; buy_options: EL_PAYPAL_BUY_OPTIONS
	)
		do
			log.enter ("update_buy_now_button")
			call_method (
				Method.update_button,
				<< new_button_locale (locale_code), new_hosted_button_id_param (id),
					Parameter.hosted_button_code, Parameter.buy_now_button_type, Parameter.button_sub_type_products,
					button_params, buy_options >>
			)
			log.exit
		end

feature -- Basic operations

	log_response_values
		do
			if has_error then
				log_or_io.put_line ("HTTP read failed")
			else
				across response_values as value loop
					log_or_io.put_labeled_string (value.key, value.item)
					log_or_io.put_new_line
				end
			end
		end

	open
		do
			open_url (api_url)
		end

feature -- Status query

	is_sandbox: BOOLEAN
		-- True if calls made to test server

	last_call_succeeded: BOOLEAN
		do
			Result := not has_error and then response_values.item (Variable.acknowledge).starts_with (Success)
			-- "SuccessWithWarning" is a possible ACK response
		end

feature {NONE} -- Factory

	new_button_locale (locale_code: STRING): EL_PAYPAL_BUTTON_LOCALE_PARAMETER
		do
			create Result.make (locale_code)
		end

	new_hosted_button_id_param (id: ZSTRING): EL_HTTP_NAME_VALUE_PARAMETER
		do
			create Result.make (Variable.hosted_button_id, id)
		end

	new_method (name: ZSTRING): EL_HTTP_NAME_VALUE_PARAMETER
		do
			create Result.make (Parameter.Method, name)
		end

	new_parameter (name, value: ZSTRING): EL_HTTP_NAME_VALUE_PARAMETER
		do
			create Result.make (name, value)
		end

feature {NONE} -- Implementation

	api_url: ZSTRING
		do
			Result := "https://api-3t.paypal.com/nvp"
			if is_sandbox then
				Result.insert_string_general (".sandbox", Result.index_of ('.', 1))
			end
		end

	call_method (method_parameter: EL_HTTP_NAME_VALUE_PARAMETER; a_parameters: ARRAY [EL_HTTP_PARAMETER])
		local
			parameter_list: EL_HTTP_PARAMETER_LIST [EL_HTTP_PARAMETER]
			value_table: EL_HTTP_HASH_TABLE
		do
			reset
			create parameter_list.make_from_array (<< credentials, api_version, method_parameter >>)
			parameter_list.append_array (a_parameters)

			value_table := parameter_list.to_table

			if log.current_routine_is_active then
				across value_table as value loop
					log.put_labeled_string (value.key, value.item)
					log.put_new_line
				end
			end
			post_parameters (value_table)
			if has_error then
				response_values.wipe_out
			else
				create response_values.make_from_nvp_string (last_string)
			end
		end

feature {NONE} -- Internal attributes

	api_version: EL_HTTP_NAME_VALUE_PARAMETER

	credentials: EL_PAYPAL_CREDENTIALS

feature {NONE} -- Constants

	Button_id_name_prefix: ZSTRING
		once
			Result := "L_HOSTEDBUTTONID"
		end

	Method: TUPLE [
		button_search, create_button, manage_button_status, get_button_details, update_button: EL_HTTP_NAME_VALUE_PARAMETER
	]
		  -- API methods
		once
			Result := [
				new_method ("BMButtonSearch"), new_method ("BMCreateButton"), new_method ("BMManageButtonStatus"),
				new_method ("BMGetButtonDetails"), new_method ("BMUpdateButton")
			]
		end

	Parameter: TUPLE [
		end_date, method, start_date: ZSTRING
		button_status_delete, button_sub_type_products, buy_now_button_type, hosted_button_code: EL_HTTP_NAME_VALUE_PARAMETER
	]
			-- API parameters
		once
			create Result
			Result.end_date := "ENDDATE"
			Result.start_date := "STARTDATE"
			Result.method := "METHOD"

			Result.button_status_delete := new_parameter (Variable.button_status, "DELETE")
			Result.button_sub_type_products := new_parameter (Variable.button_sub_type, "PRODUCTS")
			Result.buy_now_button_type := new_parameter (Variable.button_type, "BUYNOW")
			Result.hosted_button_code := new_parameter (Variable.button_code, "HOSTED")
		end

	Success: ZSTRING
		once
			Result := "Success"
		end

end
