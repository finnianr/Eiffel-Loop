note
	description: "Table to cache results of a function with multiple hashable arguments"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:37:09 GMT (Sunday 22nd September 2024)"
	revision: "8"

class
	EL_FUNCTION_CACHE_TABLE [G, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_HASH_TABLE [G, OPEN_ARGS]
		rename
			make as make_sized,
			make_equal as make_equal_table,
			item as cached_item,
			remove as remove_type
		end

create
	make, make_equal

feature {NONE} -- Initialization

	make (n: INTEGER; a_new_item: like new_item)
		do
			make_sized (n)
			new_item := a_new_item
			create argument_key
		end

	make_equal (n: INTEGER; a_new_item: like new_item)
		do
			make (n, a_new_item)
			compare_objects
		end

feature -- Access

	item (arguments: OPEN_ARGS): like cached_item
			-- Returns the cached value of `new_item.item (arguments)' if available, or else
			-- the newly calculated value
		require
			valid_arguments (arguments)
		do
			arguments.compare_objects
			if not has_key (arguments) then
				if arguments = argument_key then
					put (new_item.item (arguments), arguments.twin)
				else
					put (new_item.item (arguments), arguments)
				end
			end
			Result := found_item
		end

feature -- Contract Support

	valid_arguments (arguments: OPEN_ARGS): BOOLEAN
		-- `True' if all arguments conform to `HASHABLE' and are attached
		do
			Result := across arguments as list all
				arguments.is_reference_item (list.cursor_index)
					implies attached {HASHABLE} arguments.reference_item (list.cursor_index)
			end
		end

feature -- Element change

	set_new_item_target (target: ANY)
		do
			new_item.set_target (target)
		end

feature {NONE} -- Initialization

	argument_key: OPEN_ARGS

	new_item: FUNCTION [OPEN_ARGS, G];

note
	descendants: "[
			EL_FUNCTION_CACHE_TABLE [G, OPEN_ARGS -> TUPLE create default_create end]
				${EL_FILLED_STRING_8_TABLE}
				${EL_LOCALIZED_CURRENCY_TABLE}
				${EL_FILLED_STRING_TABLE* [STR -> READABLE_STRING_GENERAL]}
					${EL_FILLED_ZSTRING_TABLE}
					${EL_FILLED_STRING_32_TABLE}
	]"
end