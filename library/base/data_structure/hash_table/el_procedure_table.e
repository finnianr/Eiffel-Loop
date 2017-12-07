note
	description: "Summary description for {EL_PROCEDURE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 9:39:53 GMT (Saturday 2nd December 2017)"
	revision: "2"

class
	EL_PROCEDURE_TABLE

inherit
	EL_STRING_HASH_TABLE [PROCEDURE, STRING]

create
	make_equal, make, default_create
end
