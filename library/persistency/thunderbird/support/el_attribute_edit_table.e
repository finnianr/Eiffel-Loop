note
	description: "Table of actions to add XML element attribute to output string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-15 14:06:42 GMT (Saturday 15th January 2022)"
	revision: "1"

class
	EL_ATTRIBUTE_EDIT_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [PROCEDURE [ZSTRING, ZSTRING, ZSTRING]]

create
	make, make_size

end