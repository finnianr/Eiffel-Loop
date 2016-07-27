note
	description: "Stacks of templates to enable use of recursive templates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-11 12:23:06 GMT (Monday 11th April 2016)"
	revision: "5"

class
	EVOLICITY_TEMPLATE_STACK_TABLE

inherit
	HASH_TABLE [ARRAYED_STACK [EVOLICITY_COMPILED_TEMPLATE], EL_FILE_PATH]
		rename
			item as stack,
			found_item as found_stack
		end

create
	make_equal

end