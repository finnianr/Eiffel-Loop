note
	description: "Shared instance of ${CHARACTER_PROPERTY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

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