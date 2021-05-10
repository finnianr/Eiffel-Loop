note
	description: "[
		Object with `field_table' attribute of field getter-setter's. See class [$source EL_REFLECTED_FIELD_TABLE]
	]"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		Override `use_default_values' to return `False' if the default values set
		by `set_default_values' is not required.
	]"
	tests: "Class [$source REFLECTION_TEST_SET]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-10 10:26:30 GMT (Monday 10th May 2021)"
	revision: "22"

deferred class
	EL_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVE
		redefine
			is_equal, field_table
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

feature -- Basic operations

	put_comma_separated_values (line: ZSTRING)
		local
			table: like field_table csv: like CSV_escaper
			value: ZSTRING
		do
			table := field_table; csv := CSV_escaper
			create value.make_empty
			from table.start until table.after loop
				value.wipe_out
				table.item_for_iteration.append_to_string (Current, value)
				line.append (csv.escaped (value, False))
				table.forth
			end
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
				table.item_for_iteration.append_to_string (Current, value)
				list.extend (csv.escaped (value, True))
				table.forth
			end
			Result := list.joined (',')
		end

feature {EL_REFLECTION_HANDLER} -- Access

	field_table: EL_REFLECTED_FIELD_TABLE note option: transient attribute end

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

	CSV_escaper: EL_COMMA_SEPARATED_VALUE_ESCAPER
		once
			create Result.make
		end

note
	descendants: "[
			EL_REFLECTIVELY_SETTABLE*
				[$source MY_DRY_CLASS]
				[$source AIA_RESPONSE]
					[$source AIA_PURCHASE_RESPONSE]
						[$source AIA_REVOKE_RESPONSE]
					[$source AIA_GET_USER_ID_RESPONSE]
					[$source AIA_FAIL_RESPONSE]
				[$source AIA_CREDENTIAL_ID]
				[$source FCGI_REQUEST_PARAMETERS]
				[$source AIA_AUTHORIZATION_HEADER]
				[$source COUNTRY]
					[$source CAMEL_CASE_COUNTRY]
					[$source STORABLE_COUNTRY]
				[$source EL_REFLECTIVELY_SETTABLE_STORABLE]*
					[$source AIA_CREDENTIAL]
					[$source STORABLE_COUNTRY]
					[$source EL_UUID]
					[$source TEST_STORABLE]
					[$source EL_REFLECTIVE_RSA_KEY]*
						[$source EL_RSA_PRIVATE_KEY]
					[$source EL_COMMA_SEPARATED_WORDS]
					[$source EL_STORABLE_IMPL]
					[$source EL_TRANSLATION_ITEM]
				[$source PP_TRANSACTION]
				[$source JOB]
				[$source JSON_CURRENCY]
				[$source PERSON]
				[$source AIA_REQUEST]*
					[$source AIA_GET_USER_ID_REQUEST]
					[$source AIA_PURCHASE_REQUEST]
						[$source AIA_REVOKE_REQUEST]
				[$source FCGI_HTTP_HEADERS]
				[$source PP_ADDRESS]
				[$source EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]*
					[$source EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN]*
						[$source EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS]*
						[$source EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML]*
							[$source TEST_CONFIGURATION]
					[$source TEST_VALUES]
					[$source EL_FILE_MANIFEST_ITEM]
				[$source EL_REFLECTIVE_LOCALE_TEXTS]*
					[$source EL_UNINSTALL_TEXTS]
				[$source EL_DYNAMIC_MODULE_POINTERS]
					[$source EL_CURL_API_POINTERS]
					[$source EL_IMAGE_UTILS_API_POINTERS]
				[$source EL_COMMAND_LINE_OPTIONS]*
					[$source EL_APPLICATION_COMMAND_OPTIONS]
						[$source EROS_APPLICATION_COMMAND_OPTIONS]
						[$source FTP_LOGIN_OPTIONS]
						[$source TEST_WORK_DISTRIBUTER_COMMAND_OPTIONS]
						[$source EL_AUTOTEST_COMMAND_OPTIONS]
					[$source EL_BASE_COMMAND_OPTIONS]
					[$source EL_LOG_COMMAND_OPTIONS]
				[$source EL_ENUMERATION]* [N -> [$source NUMERIC]]
					[$source TL_PICTURE_TYPE_ENUM]
					[$source AIA_RESPONSE_ENUM]
					[$source AIA_REASON_ENUM]
					[$source EL_BOOLEAN_ENUMERATION]*
						[$source PP_ADDRESS_STATUS_ENUM]
					[$source PP_PAYMENT_STATUS_ENUM]
					[$source PP_PAYMENT_PENDING_REASON_ENUM]
					[$source PP_TRANSACTION_TYPE_ENUM]
					[$source EL_CURRENCY_ENUM]
					[$source EL_DESCRIPTIVE_ENUMERATION]* [N -> {[$source NUMERIC], [$source HASHABLE]}]
						[$source EROS_ERRORS_ENUM]
						[$source EL_PASSPHRASE_ATTRIBUTES_ENUM]
					[$source TL_FRAME_ID_ENUM]
					[$source TL_STRING_ENCODING_ENUM]
					[$source TL_MUSICBRAINZ_ENUM]
					[$source EL_TYPE_ID_ENUMERATION]*
						[$source EL_CLASS_TYPE_ID_ENUM]
					[$source EL_HTTP_STATUS_ENUM]
	]"
end