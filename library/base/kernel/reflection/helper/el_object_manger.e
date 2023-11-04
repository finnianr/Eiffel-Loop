note
	description: "[
		Object to "jail-break" inaccessible fields in an object.
	]"
	notes: "[
		**WARNING**
		
		Use with caution. For expert Eiffel coders only.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-04 8:49:19 GMT (Saturday 4th November 2023)"
	revision: "1"

deferred class
	EL_OBJECT_MANGER [G]

inherit
	REFLECTED_REFERENCE_OBJECT
		rename
			field as i_th_field
	 	export
	 		{NONE} all
	 	redefine
	 		default_create
	 	end

feature {NONE} -- Initialization

	default_create
		do
			item := new_item
			make (item)
			field_table := shared_field_table
		end

feature -- Access

	item: G

feature {NONE} -- Implementation

	zero_value_count (array: SPECIAL [INTEGER]): INTEGER
		do
			across array as n loop
				if n.item = 0 then
					Result := Result + 1
				end
			end
		end

	new_field_table: SPECIAL [INTEGER]
		-- table of selected field indices for reflective field access
		require
			item_set: enclosing_object = item
		local
			list: EL_STRING_8_LIST; i, index: INTEGER
		do
			list := field_names
			create Result.make_filled (0, list.count)
			from i := 1 until i > field_count loop
				index := list.index_of (field_name (i), 1)
				if index > 0 then
					Result [index - 1] := i
				end
				i := i + 1
			end
		ensure
			all_fields_matched: zero_value_count (Result) = 0
		end

feature {NONE} -- Deferred

	field_names: STRING
		-- subset of available fields as comma separated list
		deferred
		end

	shared_field_table: SPECIAL [INTEGER]
		-- define as a once object with result `new_field_table'
		deferred
		end

	new_item: like item
		deferred
		end

feature {NONE} -- Internal attributes

	field_table: SPECIAL [INTEGER]

end