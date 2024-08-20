note
	description: "Shared instance of ${CHARACTER_PROPERTY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:29:01 GMT (Tuesday 20th August 2024)"
	revision: "5"

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