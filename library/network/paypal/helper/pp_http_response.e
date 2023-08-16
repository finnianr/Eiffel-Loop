note
	description: "Deserialized response to Paypal HTTP method call"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-21 19:26:45 GMT (Friday 21st July 2023)"
	revision: "15"

class
	PP_HTTP_RESPONSE

inherit
	EL_URI_QUERY_TABLE
		rename
			make_url as make
		undefine
			is_equal
		end

	PP_SETTABLE_FROM_UPPER_CAMEL_CASE
		redefine
			new_field_printer
		end

	EL_MODULE_LIO

create
	make, make_default

feature {NONE} -- Initialization

	make_count (n: INTEGER)
		do
			make_default
		end

feature -- Basic operations

	print_values
		do
			if is_ok then
				print_fields (lio)
			else
				print_error
			end
		end

feature -- Paypal fields

	ack: STRING

	build: NATURAL

	correlation_id: STRING

	email_link: STRING

	http_read_ok: BOOLEAN

	time_stamp: EL_ISO_8601_DATE_TIME

	version: STRING

feature -- Status query

	is_ok: BOOLEAN
		do
			Result := http_read_ok and ack.starts_with (Success)
			-- "SuccessWithWarning" is a possible ACK response
		end

feature -- Element change

	set_http_read_ok (a_http_read_ok: like http_read_ok)
		do
			http_read_ok := a_http_read_ok
		end

feature {NONE} -- Implementation

	print_error
		do
			lio.put_line ("ERROR")
		end

	set_name_value (key, value: EL_ZSTRING)
		local
			table: like field_table
		do
			table := field_table
			if table.has_imported_key (key) then
				set_reflected_field (table.found_item, Current, value)
			else
				set_indexed_value (variable (key), value)
			end
		end

feature {NONE} -- Implementation

	set_indexed_value (var_key: PP_L_VARIABLE; a_value: ZSTRING)
		do
		end

	variable (key: ZSTRING): PP_L_VARIABLE
		do
			Result := Once_variable
			Result.set_from_string (key)
		end

	decoded_string (url: EL_URI_QUERY_STRING_8): ZSTRING
		do
			Result := url.decoded
		end

	new_field_printer: EL_REFLECTIVE_CONSOLE_PRINTER
			-- Fields that will not be output by `print_fields'
			-- Must be comma-separated names
		do
			create Result.make_with_hidden ("time_stamp")
		end

feature {NONE} -- Constants

	Once_variable: PP_L_VARIABLE
		once
			create Result.make_default
		end

	Success: STRING = "Success"

end