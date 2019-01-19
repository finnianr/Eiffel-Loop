note
	description: "Table of procedures with latin-1 encoded keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:28:10 GMT (Friday 18th January 2019)"
	revision: "4"

class
	EL_PROCEDURE_TABLE [K -> STRING_GENERAL create make end]

inherit
	EL_STRING_HASH_TABLE [PROCEDURE, K]

create
	make_equal, make, default_create
end
