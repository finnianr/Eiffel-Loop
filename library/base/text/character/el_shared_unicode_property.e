note
	description: "Shared instance of ${CHARACTER_PROPERTY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-08 11:27:49 GMT (Wednesday 8th February 2023)"
	revision: "3"

deferred class
	EL_SHARED_UNICODE_PROPERTY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Unicode_property: EL_UNICODE_PROPERTY
		-- Access to Unicode character properties
		once
			create Result.make
		end
end