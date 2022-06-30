note
	description: "Shared instance of [$source CHARACTER_PROPERTY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-30 8:45:23 GMT (Thursday 30th June 2022)"
	revision: "1"

deferred class
	EL_SHARED_UNICODE_PROPERTY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Unicode_property: CHARACTER_PROPERTY
		-- Access to Unicode character properties
		once
			create Result.make
		end
end