note
	description: "Duplicity routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-12 15:56:51 GMT (Wednesday 12th February 2020)"
	revision: "1"

class
	DUPLICITY_ROUTINES

feature {NONE} -- Implementation

	formatted (date: DATE): STRING
		do
			Result := date.formatted_out ("yyyy-[0]mm-[0]dd")
		end
end
