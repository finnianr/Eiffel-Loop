note
	description: "Note constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 16:11:33 GMT (Sunday 8th September 2024)"
	revision: "9"

class
	NOTE_CONSTANTS

inherit
	ANY; EL_MODULE_TUPLE

feature {NONE} -- Eiffel note constants

	Date_time_code: DATE_TIME_CODE_STRING
		once
			create Result.make (Date_time_format)
		end

	Date_time_format: STRING = "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss"

	Field: TUPLE [description, author, copyright, contact, license, date, revision: IMMUTABLE_STRING_8]
		-- in the order in which they should appear
		do
			create Result
			Tuple.fill_immutable (Result, "description, author, copyright, contact, license, date, revision")
		end

	Author_fields: ARRAY [IMMUTABLE_STRING_8]
		-- Group starting with author
		once
			Result := << Field.author, Field.copyright, Field.contact >>
			Result.compare_objects
		end

	License_fields: ARRAY [IMMUTABLE_STRING_8]
		-- Group starting with license
		once
			Result := << Field.license, Field.date, Field.revision >>
			Result.compare_objects
		end

	Verbatim_string_end: ZSTRING
		once
			Result := "]%""
		end

	Verbatim_string_start: ZSTRING
		once
			Result := "%"["
		end

end