note
	description: "Summary description for {PP_NUMBERED_VARIABLE_NAME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-16 16:13:40 GMT (Saturday 16th December 2017)"
	revision: "4"

deferred class
	PP_NUMBERED_VARIABLE_NAME_SEQUENCE

inherit
	PP_VARIABLE_NAME_SEQUENCE
		redefine
			new_name
		end

feature {NONE} -- Initialization

	make (a_number: like number)
		require
			valid_id: a_number >= 0 and a_number <= 9
		do
			number := a_number
		end

feature {NONE} -- Implementation

	new_name: ZSTRING
		local
			pos_qmark: INTEGER
		do
			Result := Precursor
			pos_qmark := Result.index_of ('?', 1)
			if pos_qmark > 0 then
				Result [pos_qmark] := number.out [1]
			end
		end

	name_prefix: ZSTRING
		deferred
		ensure then
			valid_name: Result.has ('?')
		end

	number: INTEGER

end
