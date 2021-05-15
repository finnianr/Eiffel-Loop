note
	description: "Routines to convert between objects of type [$source STRING] and [$source EL_DATE_TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-15 9:36:54 GMT (Saturday 15th May 2021)"
	revision: "2"

deferred class
	EL_DATE_TIME_CONVERSION

inherit
	ANY

	EL_SHARED_DATE_TIME

feature {NONE} -- Initialization

	make (a_format: STRING)
		do
			format := a_format
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