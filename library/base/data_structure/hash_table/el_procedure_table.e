note
	description: "Summary description for {EL_PROCEDURE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:54:31 GMT (Sunday 21st May 2017)"
	revision: "1"

class
	EL_PROCEDURE_TABLE

inherit
	EL_HASH_TABLE [PROCEDURE, STRING]

create
	make_equal, make, default_create
end
