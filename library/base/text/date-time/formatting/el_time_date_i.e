note
	description: "Base class for date time classes"
	descendants: "[
			EL_TIME_DATE_I*
				${EL_DATE}
				${EL_TIME}
				${EL_DATE_TIME}
					${EL_ISO_8601_DATE_TIME}
					${PP_DATE_TIME}
					${EL_SHORT_ISO_8601_DATE_TIME}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-03 15:18:59 GMT (Sunday 3rd November 2024)"
	revision: "17"

deferred class
	EL_TIME_DATE_I

inherit
	EL_MODULE_DATE_TIME

	EL_APPENDABLE_TO_STRING_GENERAL
		rename
			append_to as default_append_to
		undefine
			copy, is_equal, out
		end

	EL_SHARED_STRING_8_BUFFER_SCOPES

feature {NONE} -- Initialization

	make_now
		-- set current time/date according to timezone.
		do
			make_default; update
		end

	make_now_utc
		-- set the current object to today's date/time in UTC format.
		do
			make_default; update_utc
		end

	make_with_format (s: STRING; format: STRING)
		do
			across String_8_scope as scope loop
				if attached scope.item as str then
					str.append (s)
					if attached Factory.date_time_parser (format) as parser then
						parser.parse_source (str)
						make_with_parser (parser)
					end
				end
			end
		end

feature -- Access

	formatted_out (format: STRING): STRING
		do
			across String_8_scope as scope loop
				if attached scope.item as str then
					append_to (str, format)
					Result := str.twin
				end
			end
		end

	to_string: STRING
		do
			Result := out
		end

feature -- Basic operations

	append_to (general: STRING_GENERAL; format: STRING)
		do
			if attached {STRING_8} general as str_8 then
				append_to_string_8 (str_8, format)
			else
				across String_8_scope as scope loop
					if attached scope.item as str then
						append_to_string_8 (str, format)
						general.append (str)
					end
				end
			end
		end

	append_to_string_8 (str, format: STRING)
		local
			old_count: INTEGER
		do
			old_count := str.count
			if attached Factory.code_string (format) as code then
				code.append_to (str, to_shared_date_time)
			end
		ensure
			corresponds_to_format: attached Factory.code_string (format) as code
											implies code.correspond (str.substring (old str.count + 1, str.count))
		end

	default_append_to (general: STRING_GENERAL)
		do
			append_to (general, default_format_string)
		end

	update
		-- update to local time for current time-zone
		do
			if attached Time_local as t then
				t.update; update_with (t)
			end
		end

	update_utc
		-- update to UTC time
		do
			if attached Time_utc as t then
				t.update; update_with (t)
			end
		end

feature -- Element change

	set_with_parser (a_parser: EL_DATE_TIME_PARSER)
		do
			make_with_parser (a_parser)
		end

feature -- Contract support

	input_valid (s: STRING; format: STRING): BOOLEAN
		do
			across String_8_scope as scope loop
				if attached scope.item as str then
					str.append (s); str.to_upper
					Result := upper_input_valid (str, format)
				end
			end
		end

feature {NONE} -- Implementation

	upper_input_valid (upper_str: STRING; format: STRING): BOOLEAN
		do
			if attached Factory.code_string (format) as code then
				Result := valid_string_for_code (upper_str, code)
			end
		end

feature {NONE} -- Deferred Implementation

	default_format_string: STRING
		deferred
		end

	make_default
		deferred
		end

	make_with_parser (parser: EL_DATE_TIME_PARSER)
		deferred
		end

	to_shared_date_time: DATE_TIME
		deferred
		end

	update_with (system: EL_SYSTEM_TIME)
		deferred
		end

	valid_string_for_code (str: STRING; code: EL_DATE_TIME_CODE_STRING): BOOLEAN
		deferred
		end

feature {NONE} -- Constants

	Factory: EL_DATE_OR_TIME_PARSER_FACTORY
		once
			create Result.make
		end

	Time_local: EL_SYSTEM_TIME
		once
			create Result.make_local
		end

	Time_utc: EL_SYSTEM_TIME
		once
			create Result.make_utc
		end

	Once_date_time: DATE_TIME
		once
			create Result.make (1, 1, 1, 1, 1, 1)
		end

end