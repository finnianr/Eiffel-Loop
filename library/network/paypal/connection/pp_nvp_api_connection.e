note
	description: "Paypal NVP API connection accessible via `{${PP_SHARED_API_CONNECTION}}.paypal'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-23 10:23:11 GMT (Friday 23rd February 2024)"
	revision: "26"

class
	PP_NVP_API_CONNECTION

inherit
	PP_HTTP_CONNECTION
		rename
			open as open_connection
		export
			{NONE} open_url
			{PP_BUTTON_METHOD} set_post_parameters, read_string_post, has_error, reset
			{PP_SHARED_API_CONNECTION, PP_BUTTON_METHOD} last_string
		redefine
			make
		end

	EL_REFLECTIVE
		rename
			field_included as is_button_parameter,
			foreign_naming as eiffel_naming
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_configuration: PP_CONFIGURATION)
		do
			make_solitary
			Precursor (a_configuration)
			credentials := a_configuration.new_credentials
			create version.make (configuration.api_version)
			create button_search.make (Current)
			create create_button.make (Current)
			create get_button_details_method.make (Current)
			create manage_button_status.make (Current)
			create update_button.make (Current)

			across field_table as button loop
				button.item.set (Current, create {PP_BUTTON_PARAMETER}.make (button.key))
			end
			cache_dir := Directory.App_cache #+ domain_name
			File_system.make_directory (cache_dir)
		end

feature -- Access

	api_url: STRING
		do
			Result := configuration.api_url
		end

	domain_name: STRING
		-- Eg. www.sandbox.paypal.com
		do
			Result := configuration.domain_name
		end

	notify_url: STRING
		-- The URL to which PayPal posts information about the payment,
		-- in the form of Instant Payment Notification messages.
		do
			Result := configuration.notify_url
		end

feature -- Button management

	button_search_results: PP_BUTTON_SEARCH_RESULTS
		-- list all buttons since Jan 1st 2000
		do
			Result := button_search.query_result (<< create {PP_DATE_TIME_RANGE}.make_millenium >>)
		end

	create_buy_now_button (
		locale: PP_BUTTON_LOCALE; sub_parameter_list: PP_BUTTON_SUB_PARAMETER_LIST; buy_options: PP_BUY_OPTIONS
	): PP_BUTTON_QUERY_RESULTS
		do
			Result := create_button.call (<<
				locale, button_code_hosted, button_type_buynow, sub_parameter_list, buy_options
			>>)
		end

	delete_button (button: PP_HOSTED_BUTTON): PP_HTTP_RESPONSE
		do
			Result := manage_button_status.call (<< button, button_status_delete >>)
			if Result.is_ok then
				remove_cached (button.id)
			end
		end

	get_button_details (a_meta_data: PP_BUTTON_META_DATA): PP_BUTTON_DETAILS_QUERY_RESULTS
		-- get button details either from local cache or from API call
		local
			cache_path: FILE_PATH
		do
			error_code := 0
			cache_path := new_cache_path (a_meta_data.l_hosted_button_id)
			if cache_path.exists and then cache_path.modification_time = a_meta_data.l_modify_date.to_unix then
				lio.put_string (" from cache")
				create Result.make (File.plain_text (cache_path))
			else
		 		Result := get_button_details_method.query_result (<< a_meta_data.hosted_button >>)
				if last_call_succeeded then
				-- cache `last_string' that made `Result' in file
					File.write_text (cache_path, last_string)
					File.set_modification_time (cache_path, a_meta_data.l_modify_date.to_unix)
				end
		 	end
		end

	update_buy_now_button (
		locale: PP_BUTTON_LOCALE; button: PP_HOSTED_BUTTON
		sub_parameter_list: PP_BUTTON_SUB_PARAMETER_LIST; buy_options: PP_BUY_OPTIONS
	): PP_BUTTON_QUERY_RESULTS
		do
			Result := update_button.call (<<
				locale, button, button_code_hosted, button_type_buynow, button_sub_type_products,
				sub_parameter_list, buy_options
			>>)
		end

feature -- Basic operations

	open
		do
			open_connection (api_url)
		end

feature -- Status query

	has_notify_url: BOOLEAN
		do
			Result := not notify_url.is_empty
		end

	last_call_succeeded: BOOLEAN
		do
			Result := not has_error
		end

feature {PP_BUTTON_METHOD} -- Paypal parameters

	button_code_hosted: PP_BUTTON_PARAMETER
		--> BUTTONCODE=HOSTED

	button_status_delete: PP_BUTTON_PARAMETER
		--> BUTTONSTATUS=DELETE

	button_sub_type_products: PP_BUTTON_PARAMETER
		--> BUTTONSUBTYPE=PRODUCTS

	button_type_buynow: PP_BUTTON_PARAMETER
		--> BUTTONTYPE=BUYNOW

	credentials: PP_CREDENTIALS

	version: PP_API_VERSION

feature {NONE} -- Methods

	button_search: PP_BUTTON_SEARCH_METHOD

	create_button: PP_CREATE_BUTTON_METHOD

	get_button_details_method: PP_GET_BUTTON_DETAILS_METHOD

	manage_button_status: PP_MANAGE_BUTTON_STATUS_METHOD

	update_button: PP_UPDATE_BUTTON_METHOD

feature {PP_SHARED_API_CONNECTION} -- Implementation

	is_button_parameter (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.static_type = Button_parameter_type
		end

	new_cache_path (button_id: STRING): FILE_PATH
		do
			Result := cache_dir + button_id
		end

	remove_cached (button_id: STRING)
		do
			if attached new_cache_path (button_id) as cache_path then
				if cache_path.exists then
					File_system.remove_file (cache_path)
				end
			end
		end

feature {NONE} -- Internal attributes

	cache_dir: DIR_PATH

feature {NONE} -- Constants

	Button_parameter_type: INTEGER
		once
			Result := ({PP_BUTTON_PARAMETER}).type_id
		end

end