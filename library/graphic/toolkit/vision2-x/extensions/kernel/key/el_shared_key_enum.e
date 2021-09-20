note
	description: "Shared instance of [$source EL_KEY_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-20 10:25:04 GMT (Monday 20th September 2021)"
	revision: "1"

deferred class
	EL_SHARED_KEY_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Key_enum: EL_KEY_ENUM
		once
			create Result.make
		end
end