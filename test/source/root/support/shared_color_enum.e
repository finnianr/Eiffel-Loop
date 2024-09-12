note
	description: "Shared instance of ${COLOR_ENUM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-12 14:43:10 GMT (Thursday 12th September 2024)"
	revision: "1"

deferred class
	SHARED_COLOR_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Color: COLOR_ENUM
		once
			create Result.make
		end
end