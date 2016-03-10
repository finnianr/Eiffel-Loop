note
	description: "Unix compatible UCS-4 wchar_t"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:07:59 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_C_WIDE_CHARACTER_STRING

inherit
	EL_C_STRING_32

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

convert
	as_string: {EL_ASTRING}, as_string_8: {STRING}, as_string_32: {STRING_32}

end
