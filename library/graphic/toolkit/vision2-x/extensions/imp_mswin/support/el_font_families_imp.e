note
	description: "Windows implementation of [$source EL_FONT_FAMILIES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 5:23:08 GMT (Wednesday 2nd August 2023)"
	revision: "1"

class
	EL_FONT_FAMILIES_IMP

inherit
	EL_FONT_FAMILIES_I

	EV_WEL_FONT_ENUMERATOR_IMP
		rename
			font_faces as new_font_faces
		export
			{NONE} all
		undefine
			copy, default_create
		end

	WEL_FONT_PITCH_CONSTANTS
		export
			{NONE} all
		undefine
			copy, default_create
		end

	WEL_FONT_FAMILY_CONSTANTS
		export
			{NONE} all
		undefine
			copy, default_create
		end

feature {NONE} -- Implementation

	new_font_property_table: EL_IMMUTABLE_UTF_8_TABLE
		local
			font: EL_FONT_REGISTRY_ROUTINES; true_type_set: EL_HASH_SET [ZSTRING]
			bitmap: NATURAL_8; manifest, l_family: ZSTRING; char_set_then_bitmap: INTEGER
			hex_string: STRING
		do
			true_type_set := font.new_true_type_font_set

			across Reuseable.string as reuse loop
				manifest := reuse.item
				across new_font_families as family loop
					if manifest.count > 0 then
						manifest.append_character_8 (',')
					end
					char_set_then_bitmap := new_char_set_then_bitmap (family.item)
					if true_type_set.has (family.item) then
						char_set_then_bitmap := char_set_then_bitmap | Font_true_type.to_integer_32
					else
						char_set_then_bitmap := char_set_then_bitmap | Font_non_true_type.to_integer_32
					end
					hex_string := char_set_then_bitmap.to_hex_string
					hex_string.prune_all_leading ('0')
					manifest.append_string_general (hex_string)
					manifest.append_character_8 (',')
					manifest.append_string_general (family.item)
				end
				create Result.make (manifest)
			end
--			garbage collect and dispose objects created during call to `new_font_faces'
			internal_font_faces := Void; text_metrics := Void log_fonts := Void
			dispose
		end

	new_font_families: EL_SORTABLE_ARRAYED_LIST [STRING_32]
		do
			create Result.make_from_array (new_font_faces.to_array)
			Result.ascending_sort
		end

	new_char_set_then_bitmap (family: STRING_32): INTEGER
		-- combined char_set and font properties bitmp
		local
			bitmap: NATURAL_8; char_set: INTEGER
		do
			if log_fonts.has_key (family) and then attached log_fonts.found_item as l_font then
				char_set := l_font.char_set
				inspect l_font.pitch
					when Default_pitch then
						if l_font.family /= FF_modern then
							bitmap := Font_proportional
						end

					when Fixed_pitch then
						bitmap := Font_monospace

					when Variable_pitch then
						bitmap := Font_proportional
				else
					bitmap := Font_proportional
				end
			else
				bitmap := Font_proportional
			end
			Result := char_set |<< 8 | bitmap.to_integer_32
		end

end
