note
	description: "Stacks of templates to enable use of recursive templates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:04:15 GMT (Tuesday 18th March 2025)"
	revision: "7"

class
	EVC_TEMPLATE_STACK_TABLE

inherit
	EL_HASH_TABLE [ARRAYED_STACK [EVC_COMPILED_TEMPLATE], FILE_PATH]
		rename
			item as stack,
			found_item as found_stack
		end

create
	make_equal

end