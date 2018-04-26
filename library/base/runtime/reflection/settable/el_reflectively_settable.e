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
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-22 12:22:27 GMT (Sunday 22nd April 2018)"
	revision: "11"

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
				if use_default_values then
					initialize_fields
				end
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
				[$source AIA_CREDENTIAL_ID]
				[$source AIA_AUTHORIZATION_HEADER]
				[$source AIA_RESPONSE]
					[$source AIA_GET_USER_ID_RESPONSE]
					[$source AIA_PURCHASE_RESPONSE]
						[$source AIA_REVOKE_RESPONSE]
				[$source AIA_REQUEST]*
					[$source AIA_PURCHASE_REQUEST]
						[$source AIA_REVOKE_REQUEST]
					[$source AIA_GET_USER_ID_REQUEST]
				[$source EL_REFLECTIVELY_SETTABLE_STORABLE]*
				[$source EL_ENUMERATION]* [N -> {NUMERIC, HASHABLE}]
					[$source AIA_RESPONSE_ENUM]
					[$source AIA_REASON_ENUM]
					[$source EL_CURRENCY_ENUM]
					[$source EL_HTTP_STATUS_ENUM]
					[$source PP_PARAMETER_ENUM]
					[$source PP_PAYMENT_PENDING_REASON_ENUM]
					[$source PP_PAYMENT_STATUS_ENUM]
					[$source PP_TRANSACTION_TYPE_ENUM]
				[$source EL_COOKIE_SETTABLE]
				[$source EL_DYNAMIC_MODULE_POINTERS]
					[$source EL_IMAGE_UTILS_API_POINTERS]
					[$source EL_CURL_API_POINTERS]
				[$source FCGI_REQUEST_PARAMETERS]
				[$source FCGI_HTTP_HEADERS]
				[$source FCGI_SETTABLE_FROM_SERVLET_REQUEST]
				[$source MY_DRY_CLASS]
				[$source PP_ADDRESS]
				[$source PP_BUTTON_DETAIL]
				[$source PP_CREDENTIALS]
				[$source PP_REFLECTIVELY_SETTABLE]
					[$source PP_BUTTON_META_DATA]
					[$source PP_BUTTON_OPTION]
					[$source PP_HTTP_RESPONSE]
						[$source PP_BUTTON_SEARCH_RESULTS]
						[$source PP_BUTTON_QUERY_RESULTS]
							[$source PP_BUTTON_DETAILS_QUERY_RESULTS]
				[$source PP_PRODUCT_INFO]
				[$source PP_TRANSACTION]
	]"
end
