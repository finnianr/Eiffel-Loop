note
	description: "Shared directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-27 9:48:31 GMT (Sunday 27th November 2022)"
	revision: "10"

deferred class
	EL_SHARED_DIRECTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Directory: EL_DIRECTORY
			--
		once
			create Result.make_default
		end

end