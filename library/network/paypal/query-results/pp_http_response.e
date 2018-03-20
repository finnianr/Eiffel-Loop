note
	description: "Deserialized response to Paypal HTTP method call"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-02 12:24:59 GMT (Friday 2nd March 2018)"
	revision: "3"

class
	PP_HTTP_RESPONSE

inherit
	EL_URL_QUERY_TABLE
		rename
			set_name_value as set_field_value
		undefine
			is_equal
		end

	PP_REFLECTIVELY_SETTABLE
		redefine
			Hidden_fields
		end

	EL_MODULE_LIO
		undefine
			is_equal
		end

	PP_SHARED_PARAMETER_ENUM
		undefine
			is_equal
		end

create
	make_default, make

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

feature -- Access

	ack: STRING

	build: NATURAL

	correlation_id: STRING

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

	set_field_value (key, value: EL_ZSTRING)
		local
			var: like Once_variable
		do
			var := Once_variable
			var.set_from_string (key)
			set_name_value (var, value)
		end

feature {NONE} -- Implementation

	set_name_value (var_key: PP_VARIABLE; a_value: ZSTRING)
		do
			set_field (var_key.name, a_value)
		end

feature {NONE} -- Constants

	Once_variable: PP_VARIABLE
		once
			create Result.make_default
		end

	Success: STRING = "Success"

feature {NONE} -- Constants

	Hidden_fields: STRING
			-- Fields that will not be output by `print_fields'
			-- Must be comma-separated names
		once
			Result := "time_stamp"
		end

end
