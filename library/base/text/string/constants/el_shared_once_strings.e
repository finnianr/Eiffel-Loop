note
	description: "Summary description for {SHARED_REUSABLE_STRINGS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "3"

class
	EL_SHARED_ONCE_STRINGS

feature {NONE} -- Implementation

	empty_once_string: like Once_string
		do
			Result := Once_string
			Result.wipe_out
		end

	empty_once_string_8: like Once_string_8
		do
			Result := Once_string_8
			Result.wipe_out
		end

	empty_once_string_32: like Once_string_32
		do
			Result := Once_string_32
			Result.wipe_out
		end

feature {NONE} -- Constants

	Once_string: EL_ZSTRING
		once
			create Result.make_empty
		end

	Once_string_8: STRING
		once
			create Result.make_empty
		end

	Once_string_32: STRING_32
		once
			create Result.make_empty
		end

end