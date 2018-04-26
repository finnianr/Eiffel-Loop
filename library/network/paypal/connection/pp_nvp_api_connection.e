note
	description: "Paypal NVP API connection accessible via `PP_SHARED_CONNECTION'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 15:43:14 GMT (Monday 18th December 2017)"
	revision: "6"

class
	PP_NVP_API_CONNECTION

inherit
	PP_HTTP_CONNECTION
		rename
			make as make_http_connection,
			open as open_url
		export
			{NONE} open_url
			{PP_BUTTON_METHOD} last_string, set_post_parameters, read_string_post, has_error, reset
		end

	PP_SHARED_PARAMETER_ENUM

create
	make

feature {NONE} -- Initialization

	make (
		a_cert_authority_info_path: EL_FILE_PATH; a_credentials: like credentials
		a_api_version: REAL; a_is_sandbox: like is_sandbox
	)
		local
			version: ZSTRING
		do
			credentials := a_credentials
			create api_version.make (Parameter.version, a_api_version.out)
			is_sandbox := a_is_sandbox
			version := api_version.value
			if not version.has ('.') then
				version.append_string_general (".0")
			end
			make_http_connection (a_cert_authority_info_path)
			create notify_url.make_empty
			create button_status_delete.make (Parameter.button_status, "DELETE")
			create button_sub_type_products.make (Parameter.button_sub_type, "PRODUCTS")
			create buy_now_button_type.make (Parameter.button_type, "BUYNOW")
			create hosted_button_code.make (Parameter.button_code, "HOSTED")

			create button_search.make
			create create_button.make
			create get_button_details_method.make
			create manage_button_status.make
			create update_button.make
		end

feature -- Access

	notify_url: STRING
		-- The URL to which PayPal posts information about the payment,
		-- in the form of Instant Payment Notification messages.

feature -- Element change

	set_notify_url (a_notify_url: like notify_url)
		do
			notify_url := a_notify_url
		end

feature -- Button management

	button_search_results: PP_BUTTON_SEARCH_RESULTS
			-- list all buttons since year 2000
		local
			start_date, end_date: PP_DATE_TIME_PARAMETER
		do
			create start_date.make_start (Jan_1st_2000)
			create end_date.make_end (create {DATE_TIME}.make_now_utc)
			Result := button_search.query_result (Current, << start_date, end_date >>)
		end

	create_buy_now_button (
		locale_code: STRING; button_params: PP_BUTTON_SUB_PARAMETER_LIST; buy_options: PP_BUY_OPTIONS
	): PP_BUTTON_QUERY_RESULTS
		do
			Result := create_button.call (Current, <<
				new_button_locale (locale_code), hosted_button_code, buy_now_button_type, button_params, buy_options
			>>)
		end

	delete_button (id: ZSTRING): PP_HTTP_RESPONSE
		do
			Result := manage_button_status.call (Current, << new_hosted_button_id_param (id), button_status_delete >>)
		end

	get_button_details (id: ZSTRING): PP_BUTTON_DETAILS_QUERY_RESULTS
		do
		 	Result := get_button_details_method.query_result (Current, << new_hosted_button_id_param (id) >>)
		end

	update_buy_now_button (
		locale_code: STRING; id: ZSTRING; button_params: PP_BUTTON_SUB_PARAMETER_LIST; buy_options: PP_BUY_OPTIONS
	): PP_BUTTON_QUERY_RESULTS
		do
			Result := update_button.call (Current, <<
				new_button_locale (locale_code), new_hosted_button_id_param (id),
				hosted_button_code, buy_now_button_type, button_sub_type_products,
				button_params, buy_options
			>>)
		end

feature -- Basic operations

	open
		do
			open_url (api_url)
		end

feature -- Status query

	is_sandbox: BOOLEAN
		-- True if calls made to test server

	last_call_succeeded: BOOLEAN
		do
			Result := not has_error
		end

feature {NONE} -- Factory

	new_button_locale (locale_code: STRING): PP_BUTTON_LOCALE_PARAMETER
		do
			create Result.make (locale_code)
		end

	new_hosted_button_id_param (id: ZSTRING): PP_NAME_VALUE_PARAMETER
		do
			create Result.make (Parameter.hosted_button_id, id)
		end

feature {NONE} -- Implementation

	api_url: ZSTRING
		do
			Result := "https://api-3t.paypal.com/nvp"
			if is_sandbox then
				Result.insert_string_general (".sandbox", Result.index_of ('.', 1))
			end
		end

feature {PP_BUTTON_METHOD} -- Parameters

	api_version: PP_NAME_VALUE_PARAMETER

	button_status_delete: PP_NAME_VALUE_PARAMETER

	button_sub_type_products: PP_NAME_VALUE_PARAMETER

	buy_now_button_type: PP_NAME_VALUE_PARAMETER

	credentials: PP_CREDENTIALS

	hosted_button_code: PP_NAME_VALUE_PARAMETER

feature {NONE} -- Methods

	button_search: PP_BUTTON_SEARCH_METHOD

	create_button: PP_CREATE_BUTTON_METHOD

	get_button_details_method: PP_GET_BUTTON_DETAILS_METHOD

	manage_button_status: PP_MANAGE_BUTTON_STATUS_METHOD

	update_button: PP_UPDATE_BUTTON_METHOD

feature {NONE} -- Constants

	Jan_1st_2000: DATE_TIME
		once
			create Result.make (2000, 1, 1, 0, 0, 0)
		end

end
