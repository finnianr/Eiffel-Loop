note
	description: "Summary description for {EL_COPY_TREE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_COPY_TREE_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_COMMAND [EL_COPY_TREE_IMPL]

create
	make, make_default

end
