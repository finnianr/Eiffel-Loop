note
	description: "Object that is serializeable to string of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:36 GMT (Tuesday 18th March 2025)"
	revision: "6"

deferred class
	EVC_SERIALIZEABLE_AS_ZSTRING

inherit
	EVC_SERIALIZEABLE_AS_STRING_GENERAL

feature {NONE} -- Constants

	Once_medium: EL_ZSTRING_IO_MEDIUM
		-- shared medium to merge text into
		once
			create Result.make_open_write (1024)
		end

end