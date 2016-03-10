note
	description: "Summary description for {EL_WINDOWS_CODEC}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 10:15:57 GMT (Wednesday 16th December 2015)"
	revision: "5"

deferred class
	EL_WINDOWS_ZCODEC

inherit
	EL_ZCODEC
		export
			{EL_FACTORY_CLIENT} make
		end

feature -- Access

	Type: STRING = "WINDOWS"

end
