note
	description: "Numbered variable name sequence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "6"

deferred class
	PP_NUMBERED_VARIABLE_NAME_SEQUENCE

inherit
	PP_VARIABLE_NAME_SEQUENCE
		redefine
			inserts
		end

feature {NONE} -- Initialization

	make (a_number: like number)
		require
			valid_id: a_number >= 0 and a_number <= 9
		do
			number := a_number
		end

feature {NONE} -- Implementation

	inserts: TUPLE
		do
			Result := [number, count]
		end

	number: INTEGER

end
