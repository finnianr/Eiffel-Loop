note
	description: "Object that is serializeable to string of type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-23 14:13:36 GMT (Monday 23rd November 2020)"
	revision: "2"

deferred class
	EVOLICITY_SERIALIZEABLE_AS_ZSTRING

inherit
	EVOLICITY_SERIALIZEABLE_AS_STRING_GENERAL

feature {NONE} -- Constants

	Once_medium: EL_ZSTRING_IO_MEDIUM
		-- shared medium to merge text into
		once
			create Result.make_open_write (1024)
		end

end