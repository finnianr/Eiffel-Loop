note
	description: "Summary description for {EL_WINDOWS_CODEC}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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