note
	description: "Summary description for {EL_WINDOWS_CODEC}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 10:13:20 GMT (Wednesday 16th December 2015)"
	revision: "1"

deferred class
	EL_WINDOWS_CODEC

inherit
	EL_CODEC
		export
			{EL_FACTORY_CLIENT} make
		end

feature -- Access

	Type: STRING = "WINDOWS"

end