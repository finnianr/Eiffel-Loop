note
	description: "Convert [$source READABLE_STRING_GENERAL] to type `G'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 16:28:28 GMT (Wednesday 5th October 2022)"
	revision: "4"

deferred class
	EL_READABLE_STRING_GENERAL_TO_TYPE [G]

inherit
	EL_LAZY_ATTRIBUTE
		rename
			item as type_description,
			new_item as new_type_description,
			actual_item as actual_type_description
		end

	EL_MODULE_TUPLE
		export
			{ANY} Tuple
		end

feature {EL_MODULE_EIFFEL} -- Initialization

	make
		do
			type := {G}
		end

feature -- Access

	type: TYPE [ANY]

	type_id: INTEGER
		do
			Result := type.type_id
		end

feature -- Status query

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `G'
		do
			Result := True
		end

	is_path: BOOLEAN
		do
			Result := False
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): G
		require
			valid_string: is_convertible (str)
		deferred
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: G; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		require
			valid_index: a_tuple.valid_index (index)
			valid_type_at_index: Tuple.type_array (a_tuple)[index] ~ type
		deferred
		end

feature {NONE} -- Implementation

	new_type_description: STRING
		-- terse English language description of type
		local
			name, last_part: IMMUTABLE_STRING_8
			underscore_index: INTEGER
		do
			name := type.name
			underscore_index := name.last_index_of ('_', name.count)
			if underscore_index > 0 then
				last_part := name.substring (underscore_index + 1, name.count)
				if last_part.is_integer then
					Result := last_part + "-bit " + name.substring (1, underscore_index - 1)
					Result.to_lower
					if across << "REAL", "NATURAL" >> as list some name.has_substring (list.item) end then
						Result.append (" number")
					end
				else
					Result := name
					Result.to_lower
				end
			else
				Result := name + " value"
				Result.to_lower
			end
		end

end