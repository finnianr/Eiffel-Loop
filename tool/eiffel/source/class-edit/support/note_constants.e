note
	description: "Summary description for {EIFFEL_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-28 17:34:41 GMT (Friday 28th July 2017)"
	revision: "3"

class
	NOTE_CONSTANTS

feature {NONE} -- Eiffel note constants


	Date_time_code: DATE_TIME_CODE_STRING
		once
			create Result.make (Date_time_format)
		end

	Date_time_format: STRING = "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss"

	Field: TUPLE [author, copyright, contact, license, date, revision: STRING]
		-- in the order in which they should appear
		do
			create Result
			Result := ["author", "copyright", "contact", "license", "date", "revision"]
		end

	Field_names: EL_STRING_8_LIST
			--
		once
			create Result.make_from_tuple (Field)
			Result.compare_objects
		end

end
