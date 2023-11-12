note
	description: "Convert [$source READABLE_STRING_GENERAL] to type `G'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-12 13:12:12 GMT (Sunday 12th November 2023)"
	revision: "13"

deferred class
	EL_READABLE_STRING_GENERAL_TO_TYPE [G]

inherit
	EL_LAZY_ATTRIBUTE
		rename
			item as type_description,
			new_item as new_type_description,
			actual_item as actual_type_description
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_IMP
		export
			{NONE} all
		end

	EL_TYPE_CONVERSION_HANDLER

	SED_UTILITIES
		rename
			abstract_type as abstract_type_of_type
		export
			{NONE} all
		end

	EL_MODULE_TUPLE

	EL_SHARED_STRING_8_BUFFER_SCOPES

feature {EL_MODULE_EIFFEL} -- Initialization

	make
		do
			type := {G}
			type_id := type.type_id
			abstract_type := abstract_type_of_type (type_id)
		end

feature -- Access

	abstract_type: INTEGER

	type: TYPE [ANY]

	type_id: INTEGER

feature -- Status query

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `G'
		do
			Result := True
		end

	is_latin_1: BOOLEAN
		-- `True' if type can be always be represented by Latin-1 encoded string
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

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): G
		do
			across String_8_scope as scope loop
				Result := as_type (scope.substring_item (str, start_index, end_index))
			end
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: G; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		require
			valid_tuple_item: valid_tuple_item (a_tuple, index)
		deferred
		end

	valid_tuple_item (a_tuple: TUPLE; index: INTEGER): BOOLEAN
		do
			if a_tuple.valid_index (index) then
				Result := {ISE_RUNTIME}.type_conforms_to (type_id, Tuple.type_array (a_tuple)[index].type_id)
			end
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
				else
					Result := name
					Result.to_lower
				end
			else
				Result := name + " value"
				Result.to_lower
			end
		end

feature {NONE} -- Constants

	Number_suffix: STRING = " number"
end