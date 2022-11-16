note
	description: "Evolicity object table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EVOLICITY_OBJECT_TABLE [G]

inherit
	EL_STRING_HASH_TABLE [G, STRING]

create
	default_create, make, make_equal, make_size

end