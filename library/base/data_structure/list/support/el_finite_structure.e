note
	description: "[
		Routines that can be applied to current finite structure conforming to [$source FINITE [G]]
		by implementing deferred routine **current_structure** as:

			current_structure: FINITE [G]
				do
					Result := Current
				end

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-14 16:54:58 GMT (Friday 14th October 2022)"
	revision: "2"

deferred class
	EL_FINITE_STRUCTURE [G]

inherit
	EL_MODULE_EIFFEL

feature -- To numeric map list

	double_map_list (to_key: FUNCTION [G, DOUBLE]): EL_ARRAYED_MAP_LIST [DOUBLE, G]
		require
			valid_to_key: container_item.is_valid_for (to_key)
		do
			create Result.make_from_values (current_finite, to_key)
		end

	integer_map_list (to_key: FUNCTION [G, INTEGER]): EL_ARRAYED_MAP_LIST [INTEGER, G]
		require
			valid_to_key: container_item.is_valid_for (to_key)
		do
			create Result.make_from_values (current_finite, to_key)
		end

	natural_map_list (to_key: FUNCTION [G, NATURAL]): EL_ARRAYED_MAP_LIST [NATURAL, G]
		require
			valid_to_key: container_item.is_valid_for (to_key)
		do
			create Result.make_from_values (current_finite, to_key)
		end

	real_map_list (to_key: FUNCTION [G, REAL]): EL_ARRAYED_MAP_LIST [REAL, G]
		require
			valid_to_key: container_item.is_valid_for (to_key)
		do
			create Result.make_from_values (current_finite, to_key)
		end

feature -- To string map list

	string_32_map_list (to_key: FUNCTION [G, STRING_32]): EL_ARRAYED_MAP_LIST [STRING_32, G]
		require
			valid_value_function: container_item.is_valid_for (to_key)
		do
			create Result.make_from_values (current_finite, to_key)
		end

	string_8_map_list (to_key: FUNCTION [G, STRING]): EL_ARRAYED_MAP_LIST [STRING, G]
		require
			valid_value_function: container_item.is_valid_for (to_key)
		do
			create Result.make_from_values (current_finite, to_key)
		end

	string_map_list (to_key: FUNCTION [G, ZSTRING]): EL_ARRAYED_MAP_LIST [ZSTRING, G]
		require
			valid_value_function: container_item.is_valid_for (to_key)
		do
			create Result.make_from_values (current_finite, to_key)
		end

feature -- Contract Support

	container_item: EL_CONTAINER_ITEM [G]
		do
			create Result.make (current_finite)
		end

feature {NONE} -- Implementation

	current_finite: FINITE [G]
		deferred
		end
end