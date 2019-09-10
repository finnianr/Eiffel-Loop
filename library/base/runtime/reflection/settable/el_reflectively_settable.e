note
	description: "[
		Object with `field_table' attribute of field getter-setter's. See class [$source EL_REFLECTED_FIELD_TABLE]
	]"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		Override `use_default_values' to return `False' if the default values set
		by `set_default_values' is not required.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 8:05:29 GMT (Tuesday 10th September 2019)"
	revision: "15"

deferred class
	EL_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVE
		redefine
			Except_fields, is_equal, field_table
		end

feature {NONE} -- Initialization

	make_default
		do
			if not attached field_table then
				field_table := Meta_data_by_type.item (Current).field_table
			end
			if use_default_values then
				initialize_fields
			end
		end

feature -- Access

	comma_separated_names: STRING
		--
		do
			Result := field_name_list.joined (',')
		end

	comma_separated_values: ZSTRING
		--
		local
			table: like field_table; list: EL_ZSTRING_LIST; csv: like CSV_escaper
			value: ZSTRING
		do
			table := field_table; csv := CSV_escaper
			create list.make (table.count)
			create value.make_empty
			from table.start until table.after loop
				value.wipe_out
				value.append_string_general (table.item_for_iteration.to_string (Current))
				list.extend (csv.escaped (value, True))
				table.forth
			end
			Result := list.joined (',')
		end

feature {EL_REFLECTION_HANDLER} -- Access

	field_table: EL_REFLECTED_FIELD_TABLE

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := all_fields_equal (other)
		end

feature {NONE} -- Implementation

	use_default_values: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Constants

	Except_fields: STRING
			-- list of comma-separated fields to be excluded
		once
			Result := "field_table"
		end

	CSV_escaper: EL_COMMA_SEPARATED_VALUE_ESCAPER
		once
			create Result.make
		end

note
	descendants: "[
			EL_REFLECTIVELY_SETTABLE*
				[$source MY_DRY_CLASS]
				[$source AIA_CREDENTIAL_ID]
				[$source JOB]
				[$source PP_ADDRESS]
				[$source JSON_CURRENCY]
				[$source AIA_RESPONSE]
					[$source AIA_PURCHASE_RESPONSE]
						[$source AIA_REVOKE_RESPONSE]
					[$source AIA_GET_USER_ID_RESPONSE]
				[$source AIA_REQUEST]*
					[$source AIA_GET_USER_ID_REQUEST]
					[$source AIA_PURCHASE_REQUEST]
						[$source AIA_REVOKE_REQUEST]
				[$source PP_TRANSACTION]
					[$source PAYPAL_TRANSACTION]
				[$source EL_COOKIE_SETTABLE]*
					[$source LICENSE_INFO]
				[$source PP_ADDRESS]
					[$source ADDRESS]
				[$source PP_PRODUCT_INFO]
				[$source FCGI_HTTP_HEADERS]
				[$source EL_REFLECTIVELY_SETTABLE_STORABLE]*
					[$source AIA_CREDENTIAL]
					[$source EL_UUID]
					[$source EL_STORABLE_IMPL]
					[$source EL_TRANSLATION_ITEM]
					[$source MP3_IDENTIFIER]
				[$source PP_BUTTON_DETAIL]
				[$source PP_REFLECTIVELY_SETTABLE]*
					[$source PP_SETTABLE_FROM_UPPER_CAMEL_CASE]
						[$source PP_BUTTON_META_DATA]
						[$source PP_HTTP_RESPONSE]
							[$source PP_BUTTON_SEARCH_RESULTS]
							[$source PP_BUTTON_QUERY_RESULTS]
								[$source PP_BUTTON_DETAILS_QUERY_RESULTS]
						[$source PP_BUTTON_OPTION]
					[$source PP_CONVERTABLE_TO_PARAMETER_LIST]
						[$source PP_HOSTED_BUTTON]
						[$source PP_API_VERSION]
						[$source PP_CREDENTIALS]
						[$source PP_DATE_TIME_RANGE]
						[$source PP_BUTTON_LOCALE]
						[$source PP_BUTTON_METHOD]
							[$source PP_CREATE_BUTTON_METHOD]
							[$source PP_GET_BUTTON_DETAILS_METHOD]
							[$source PP_UPDATE_BUTTON_METHOD]
							[$source PP_BUTTON_SEARCH_METHOD]
							[$source PP_MANAGE_BUTTON_STATUS_METHOD]
				[$source EL_ENUMERATION]*
					[$source AIA_RESPONSE_ENUM]
					[$source AIA_REASON_ENUM]
					[$source EL_CURRENCY_ENUM]
					[$source EL_HTTP_STATUS_ENUM]
					[$source PP_PAYMENT_PENDING_REASON_ENUM]
					[$source PP_PAYMENT_STATUS_ENUM]
					[$source PP_L_VARIABLE_ENUM]
					[$source PP_TRANSACTION_TYPE_ENUM]
				[$source FCGI_REQUEST_PARAMETERS]
				[$source FCGI_SETTABLE_FROM_SERVLET_REQUEST]*
				[$source EL_CONVERTABLE_TO_HTTP_PARAMETER_LIST]*
					[$source PP_CONVERTABLE_TO_PARAMETER_LIST]
				[$source EL_DYNAMIC_MODULE_POINTERS]
					[$source EL_IMAGE_UTILS_API_POINTERS]
					[$source EL_CURL_API_POINTERS]
				[$source EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]*
					[$source EL_BOOK_INFO]
					[$source RBOX_IRADIO_ENTRY]
						[$source RBOX_IGNORED_ENTRY]
							[$source RBOX_SONG]
								[$source RBOX_CORTINA_SONG]
									[$source RBOX_CORTINA_TEST_SONG]
								[$source RBOX_TEST_SONG]
									[$source RBOX_CORTINA_TEST_SONG]
	]"
end
