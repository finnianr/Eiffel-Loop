note
	description: "Shared instance of [$source EL_UTF_8_SEQUENCE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-08 12:29:14 GMT (Monday 8th February 2021)"
	revision: "1"

deferred class
	EL_SHARED_UTF_8_SEQUENCE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Utf_8_sequence: EL_UTF_8_SEQUENCE
		once
			create Result.make
		end

end