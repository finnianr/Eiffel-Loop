note
	description: "Object that is serializeable to string of type [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:57:12 GMT (Tuesday 2nd March 2021)"
	revision: "3"

deferred class
	EVOLICITY_SERIALIZEABLE_AS_STRING_8

inherit
	EVOLICITY_SERIALIZEABLE_AS_STRING_GENERAL

feature {NONE} -- Constants

	Once_medium: EL_STRING_8_IO_MEDIUM
		-- shared medium to merge text into
		once
			create Result.make_open_write (1024)
		end

end