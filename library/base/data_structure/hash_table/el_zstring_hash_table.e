note
	description: "Summary description for {EL_STRING_HASH_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 10:26:38 GMT (Saturday 2nd December 2017)"
	revision: "6"

class
	EL_ZSTRING_HASH_TABLE [G]

inherit
	EL_STRING_HASH_TABLE [G, ZSTRING]

create
	default_create, make, make_size, make_equal, make_from_array

end
