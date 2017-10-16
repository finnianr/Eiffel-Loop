note
	description: "Stacks of templates to enable use of recursive templates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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