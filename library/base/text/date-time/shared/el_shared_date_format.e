note
	description: "Shared instance of ${EL_DATE_FORMATS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-09 13:18:23 GMT (Friday 9th June 2023)"
	revision: "1"

deferred class
	EL_SHARED_DATE_FORMAT

inherit
	EL_ANY_SHARED

feature -- Contract Support

	valid_format (a_format: STRING): BOOLEAN
		do
			Result := Date_format.All_formats.has (a_format)
		end

feature {NONE} -- Constants

	Date_format: EL_DATE_FORMATS
		once
			create Result
		end
end