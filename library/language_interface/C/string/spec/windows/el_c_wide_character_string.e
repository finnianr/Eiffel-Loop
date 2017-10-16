note
	description: "Windows compatible UTF-16 wchar_t"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_C_WIDE_CHARACTER_STRING

inherit
	EL_C_STRING_16

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

convert
	as_string: {ZSTRING}, as_string_8: {STRING}, as_string_32: {STRING_32}

end