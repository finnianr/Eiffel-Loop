note
	description: "Routines to convert between objects of type ${STRING_8} and ${EL_DATE_TIME}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_DATE_TIME_CONVERSION

inherit
	ANY

	EL_MODULE_DATE_TIME

feature {NONE} -- Initialization

	make (a_format: STRING)
		do
			format := a_format
		end

feature -- Basic operations

	append_to (str: STRING; dt: EL_DATE_TIME)
		deferred
		end

feature -- Access

	format: STRING

	formatted_out (dt: EL_DATE_TIME): STRING
		deferred
		end

	modified_string (s: STRING): STRING
		deferred
		end

feature -- Status query

	is_valid_string (s: STRING): BOOLEAN
		deferred
		end

feature {NONE} -- Constants

	Buffer_8: EL_STRING_8_BUFFER
		once
			create Result
		end
end