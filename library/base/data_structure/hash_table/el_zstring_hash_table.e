note
	description: "Zstring hash table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "7"

class
	EL_ZSTRING_HASH_TABLE [G]

inherit
	EL_STRING_HASH_TABLE [G, ZSTRING]

create
	default_create, make, make_size, make_equal, make_from_array

end
