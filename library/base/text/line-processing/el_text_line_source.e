note
	description: "Summary description for {EL_STRING_MEDIUM_LINE_SOURCE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-18 15:59:25 GMT (Monday 18th January 2016)"
	revision: "5"

class
	EL_TEXT_LINE_SOURCE

inherit
	EL_LINE_SOURCE [EL_STRING_IO_MEDIUM]
		redefine
			make_default, make, set_decoder
		end

create
	make, make_from_string, make_from_utf_8

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			source := Default_source
		end

	make (a_source: EL_STRING_IO_MEDIUM)
		do
			Precursor (a_source)
			set_decoder
		end

	make_from_string (a_string: ZSTRING)
		do
			make (create {EL_ZSTRING_IO_MEDIUM}.make_open_read_from_text (a_string))
		end

	make_from_utf_8 (a_utf_8_string: STRING)
		do
			make (create {EL_UTF_STRING_8_IO_MEDIUM}.make_open_read_from_text (a_utf_8_string))
		end

feature {NONE} -- Implementation

	set_decoder
		do
			if attached {EL_ZSTRING_IO_MEDIUM} source then
				create {EL_ZSTRING_LINE_READER} decoder
			else
				Precursor
			end
		end

feature {NONE} -- Constants

	Default_source: EL_ZSTRING_IO_MEDIUM
		once
			create Result.make (0)
		end
end