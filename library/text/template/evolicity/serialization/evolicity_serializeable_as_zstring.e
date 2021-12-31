note
	description: "Object that is serializeable to string of type [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-31 17:00:11 GMT (Friday 31st December 2021)"
	revision: "3"

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