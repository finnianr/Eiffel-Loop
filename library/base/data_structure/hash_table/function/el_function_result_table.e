note
	description: "[
		Object for caching the result of a call to function `new_item' for each
		generating type of the generic parameter `TARGET'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:38:56 GMT (Sunday 22nd September 2024)"
	revision: "7"

class
	EL_FUNCTION_RESULT_TABLE [TARGET, R]

inherit
	EL_HASH_TABLE [R, INTEGER]
		rename
			make as make_sized,
			item as cached_item,
			remove as remove_type
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER; a_new_item: like new_item)
		require
			target_open: not a_new_item.is_target_closed
		do
			make_sized (n)
			new_item := a_new_item
		end

feature -- Access

	item (target: TARGET): like cached_item
			-- Returns a `new_item' or else the `cached_item' for the generating type of `target'
		local
			type_id: INTEGER
		do
			type_id := {ISE_RUNTIME}.dynamic_type (target)
			if has_key (type_id) then
				Result := found_item
			else
				Result := new_item (target)
				extend (Result, type_id)
			end
		end

feature -- Removal

	remove (object: TARGET)
		do
			remove_type ({ISE_RUNTIME}.dynamic_type (object))
		end

feature {NONE} -- Initialization

	new_item: FUNCTION [TARGET, R]

end