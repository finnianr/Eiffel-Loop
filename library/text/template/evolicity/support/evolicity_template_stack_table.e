note
	description: "Stacks of templates to enable use of recursive templates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EVOLICITY_TEMPLATE_STACK_TABLE

inherit
	HASH_TABLE [ARRAYED_STACK [EVOLICITY_COMPILED_TEMPLATE], FILE_PATH]
		rename
			item as stack,
			found_item as found_stack
		end

create
	make_equal

end