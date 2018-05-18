note
	description: "Table of procedures with latin-1 encoded keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-18 8:20:03 GMT (Friday 18th May 2018)"
	revision: "3"

class
	EL_PROCEDURE_TABLE

inherit
	EL_STRING_HASH_TABLE [PROCEDURE, STRING]

create
	make_equal, make, default_create
end
