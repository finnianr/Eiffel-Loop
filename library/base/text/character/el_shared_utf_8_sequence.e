note
	description: "Shared instance of ${EL_UTF_8_SEQUENCE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_SHARED_UTF_8_SEQUENCE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Utf_8_sequence: EL_UTF_8_SEQUENCE
		once
			create Result.make
		end

end