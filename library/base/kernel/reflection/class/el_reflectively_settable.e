note
	description: "[
		Object with `field_table' attribute of field getter-setter's. See class ${EL_FIELD_TABLE}
	]"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		Override `use_default_values' to return `False' if the default values set
		by `set_default_values' is not required.
	]"
	tests: "Class ${REFLECTION_TEST_SET}"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 12:19:04 GMT (Friday 21st March 2025)"
	revision: "41"

deferred class
	EL_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVE
		redefine
			field_comparison, is_equal
		end

	EL_MAKEABLE
		rename
			make as make_default
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default
		do
			if use_default_values then
				initialize_fields
			end
		end

feature -- Basic operations

	write_to (writable: EL_WRITABLE)
		do
			field_list.write (Current, writable)
		end

	write_to_memory (memory: EL_MEMORY_READER_WRITER)
		do
			field_list.write_to_memory (Current, memory)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			if field_comparison then
				Result := all_fields_equal (other)
			else
				Result := is_equal_except (other) -- {ANY}.is_equal
			end
		end

feature {NONE} -- Implementation

	use_default_values: BOOLEAN
		do
			Result := True
		end

	field_comparison: BOOLEAN
		do
			Result := True
		end

note
	descendants: "[
			EL_REFLECTIVELY_SETTABLE*
				${MY_DRY_CLASS}
				${EL_HTML_META_VALUES}
				${EL_NETWORK_DEVICE_IMP}
				${EL_WAYBACK_CLOSEST}
				${EL_REFLECTIVELY_SETTABLE_STORABLE*}
					${EL_UUID}
					${EL_MP3_IDENTIFIER}
					${COUNTRY}
						${CAMEL_CASE_COUNTRY}
					${AIA_CREDENTIAL}
					${TEST_STORABLE}
					${EL_REFLECTIVE_RSA_KEY*}
						${EL_RSA_PRIVATE_KEY}
						${EL_RSA_PUBLIC_KEY}
					${EL_COMMA_SEPARATED_WORDS}
					${PROVINCE}
					${EL_IP_ADDRESS_GEOLOCATION}
						${EL_IP_ADDRESS_GEOGRAPHIC_INFO}
					${EL_TRANSLATION_ITEM}
				${EVC_REFLECTIVE_SERIALIZEABLE*}
				${PP_TRANSACTION}
				${JOB}
				${JSON_CURRENCY}
				${PERSON}
				${EL_HTTP_HEADERS}
				${AIA_CREDENTIAL_ID}
				${AIA_RESPONSE}
					${AIA_FAIL_RESPONSE}
					${AIA_GET_USER_ID_RESPONSE}
					${AIA_PURCHASE_RESPONSE}
						${AIA_REVOKE_RESPONSE}
				${AIA_REQUEST*}
					${AIA_GET_USER_ID_REQUEST}
					${AIA_PURCHASE_REQUEST}
						${AIA_REVOKE_REQUEST}
				${AIA_AUTHORIZATION_HEADER}
				${FCGI_HTTP_HEADERS}
				${FCGI_REQUEST_PARAMETERS}
				${TB_EMAIL}
				${EL_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER*}
					${PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER}
						${PP_HOSTED_BUTTON}
				${PP_REFLECTIVELY_SETTABLE*}
					${PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER}
					${PP_SETTABLE_FROM_UPPER_CAMEL_CASE}
						${PP_HTTP_RESPONSE}
							${PP_BUTTON_QUERY_RESULTS}
				${EL_DYNAMIC_MODULE_POINTERS}
					${EL_IMAGE_UTILS_API_POINTERS}
					${EL_CURL_API_POINTERS}
					
		See also:
		
		1. descendants of ${EL_ENUMERATION* [N -> NUMERIC]}
		3. descendants of ${EL_COMMAND_LINE_OPTIONS}
		5. descendants of ${EL_OS_COMMAND_I*}
	]"
end