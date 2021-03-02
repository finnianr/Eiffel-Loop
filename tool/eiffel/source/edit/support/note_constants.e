note
	description: "Note constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 15:35:27 GMT (Tuesday 2nd March 2021)"
	revision: "6"

class
	NOTE_CONSTANTS

feature {NONE} -- Eiffel note constants

	Date_time_code: DATE_TIME_CODE_STRING
		once
			create Result.make (Date_time_format)
		end

	Date_time_format: STRING = "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss"

	Field: TUPLE [description, author, copyright, contact, license, date, revision: STRING]
		-- in the order in which they should appear
		do
			create Result
			Result := ["description", "author", "copyright", "contact", "license", "date", "revision"]
		end

	Author_fields: ARRAY [STRING]
		-- Group starting with author
		once
			Result := << Field.author, Field.copyright, Field.contact >>
			Result.compare_objects
		end

	License_fields: ARRAY [STRING]
		-- Group starting with license
		once
			Result := << Field.license, Field.date, Field.revision >>
			Result.compare_objects
		end

	Field_names: EL_STRING_8_LIST
			--
		once
			create Result.make_from_tuple (Field)
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