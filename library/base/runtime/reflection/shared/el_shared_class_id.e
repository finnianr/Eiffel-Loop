note
	description: "Shared instance of class [$source EL_CLASS_TYPE_ID_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 12:22:26 GMT (Thursday 30th January 2020)"
	revision: "1"

deferred class
	EL_SHARED_CLASS_ID

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Class_id: EL_CLASS_TYPE_ID_ENUM
		once
			create Result.make
		end
end
