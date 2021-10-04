note
	description: "Table to cache results of a function with multiple hashable arguments"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-04 12:49:43 GMT (Monday 4th October 2021)"
	revision: "1"

class
	EL_FUNCTION_CACHE_TABLE [G, OPEN_ARGS -> TUPLE create default_create end]

inherit
	HASH_TABLE [G, OPEN_ARGS]
		rename
			make as make_table,
			make_equal as make_equal_table,
			item as table_item,
			remove as remove_type
		end

create
	make, make_equal

feature {NONE} -- Initialization

	make (n: INTEGER; a_new_item: like new_item)
		do
			make_table (n)
			create argument_key
			new_item := a_new_item
		end

	make_equal (n: INTEGER; a_new_item: like new_item)
		do
			make_equal_table (n)
			create argument_key
			new_item := a_new_item
		end

feature -- Access

	item (arguments: OPEN_ARGS): like table_item
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
		-- `True' if all arguments are hashable and attached
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until not Result or else i > arguments.count loop
				if arguments.item_code (i) = {TUPLE}.Reference_code then
					Result := attached {HASHABLE} arguments.reference_item (i)
				end
				i := i + 1
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
				[$source EL_LOCALIZED_CURRENCY_TABLE]
				[$source EL_FILLED_STRING_8_TABLE]
				[$source EL_FILLED_STRING_TABLE]* [STR -> [$source READABLE_STRING_GENERAL]]
					[$source EL_FILLED_STRING_32_TABLE]
					[$source EL_FILLED_ZSTRING_TABLE]
	]"
end