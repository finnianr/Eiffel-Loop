note
	description: "[
		Compact table of fonts available on system with query by property specified in [$source EL_FONT_PROPERTY]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 8:30:35 GMT (Monday 7th August 2023)"
	revision: "2"

deferred class
	EL_FONT_FAMILIES_I

inherit
	EL_FONT_PROPERTY
		export
			{NONE} all
		end

feature -- Access

	new_query_list (
		width_bitmap, type_bitmap: NATURAL_8; excluded_char_sets: detachable ARRAY [INTEGER]
	): EL_COMPACT_ZSTRING_LIST
		-- fonts that have width properties if `width_bitmap' > 0
		-- and fonts that have type properties if `type_bitmap' > 0
		local
			utf_8_list: EL_IMMUTABLE_UTF_8_LIST; hexadecimal: EL_HEXADECIMAL_CONVERTER
			bitmap: NATURAL_8; included: BOOLEAN; char_set, char_set_then_bitmap: INTEGER
		do
			create utf_8_list.make (property_table.count)
			across property_table as table loop
				char_set_then_bitmap := hexadecimal.to_integer (table.utf_8_item)

				char_set := char_set_then_bitmap |>> 8; bitmap := char_set_then_bitmap.to_natural_8
				if width_bitmap.to_boolean then
					included := ((bitmap & Font_mask_width) & width_bitmap).to_boolean
				end
				if type_bitmap.to_boolean then
					included := included and ((bitmap & Font_mask_type) & type_bitmap).to_boolean
				end
				if attached excluded_char_sets as char_sets then
					included := included and not char_sets.has (char_set)
				end
				if included then
					utf_8_list.extend (table.key)
				end
			end
			utf_8_list.trim
			create Result.make (utf_8_list)
		end

feature -- Status query

	has (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := property_table.has_general (name)
		end

feature {NONE} -- Implementation

	new_property_table: EL_IMMUTABLE_UTF_8_TABLE
		-- table of hexadecimal font property bitmaps from class `EL_FONT_PROPERTY'
		deferred
		ensure
			not_empty: Result.count > 0
		end

feature {NONE} -- Internal attributes

	property_table: EL_IMMUTABLE_UTF_8_TABLE
		-- table of hexadecimal font property bitmaps from class `EL_FONT_PROPERTY' (digits 0 - 1)
		-- plus {EV_FONT}.char_set for Windows (digits 2 - 3)

end
