note
	description: "Makeable from string 8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_MAKEABLE_FROM_STRING_8

inherit
	EL_MAKEABLE_FROM_STRING_GENERAL

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): STRING_8
		do
			Result := general.to_string_8
		end
end
