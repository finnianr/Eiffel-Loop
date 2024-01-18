note
	description: "Windows implementation of ${EL_FONT_FAMILIES_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-22 8:35:11 GMT (Wednesday 22nd November 2023)"
	revision: "3"

class
	EL_FONT_FAMILIES_IMP

inherit
	EL_FONT_FAMILIES_I
		redefine
			default_create
		end

	EL_WINDOWS_IMPLEMENTATION

	EL_SHARED_ZSTRING_BUFFER_SCOPES

feature {NONE} -- Initialization

	default_create
		do
			property_table := new_property_table
		end

feature {NONE} -- Implementation

	is_true_type (true_type_set: EL_HASH_SET [ZSTRING]; family: STRING_32): BOOLEAN
		-- table of hexadecimal font property bitmaps from class `EL_FONT_PROPERTY'
		do
			across String_scope as scope loop
				Result := true_type_set.has (scope.copied_item (family))
			end
		end

	new_font_families_map: EL_ARRAYED_MAP_LIST [STRING_32, INTEGER]
		local
			enumerator: EL_WEL_FONT_ENUMERATOR_IMP
		do
			create enumerator
			Result := enumerator.new_font_families_map
		end

	new_true_type_set: EL_HASH_SET [ZSTRING]
		local
			font: EL_FONT_REGISTRY_ROUTINES
		do
			Result := font.new_true_type_font_set
		end

end