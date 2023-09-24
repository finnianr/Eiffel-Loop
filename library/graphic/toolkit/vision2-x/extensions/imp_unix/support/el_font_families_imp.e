note
	description: "Unix implementation of [$source EL_FONT_FAMILIES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 5:23:48 GMT (Wednesday 2nd August 2023)"
	revision: "1"

class
	EL_FONT_FAMILIES_IMP

inherit
	EL_FONT_FAMILIES_I

	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Implementation

	new_font_families: EL_SORTABLE_ARRAYED_LIST [STRING_32]
		do
			if attached {EV_APPLICATION_IMP} implementation.application_i as app_imp then
				create Result.make_from_array (app_imp.font_names_on_system.to_array)
				Result.ascending_sort
			else
				create Result.make (0)
			end
		end

	new_font_property_table: EL_IMMUTABLE_UTF_8_TABLE
		-- table of hexadecimal font property bitmaps from class `EL_FONT_PROPERTY'
		local
			bitmap: NATURAL_8; manifest, modified_name: ZSTRING; true_type_set: EL_HASH_SET [ZSTRING]
		do
			true_type_set := new_true_type_set

			across Reuseable.string as reuse loop
				manifest := reuse.item
				across new_font_families as family loop
					if manifest.count > 0 then
						manifest.append_character_8 (',')
					end
					if Text.is_proportional (family.item) then
						bitmap := Font_proportional
					else
						bitmap := Font_monospace
					end
					modified_name := family.item
					modified_name.prune_all (' ')
					if true_type_set.has (modified_name) then
						bitmap := bitmap | Font_true_type
					else
						bitmap := bitmap | Font_non_true_type
					end
					manifest.append_character_8 (bitmap.to_hex_character)
					manifest.append_character_8 (',')
					manifest.append_string_general (family.item)
				end
				create Result.make (manifest)
			end
		end

	new_true_type_set: EL_HASH_SET [ZSTRING]
		do
			if attached File_system.files_with_extension ("/usr/share/fonts/truetype", "ttf", True) as true_type_list then
				create Result.make (true_type_list.count)
				across true_type_list as list loop
					if attached list.item.base_name as name then
						remove_qualifiers (name)
						Result.put (name)
					end
				end
			end
		end

	remove_qualifiers (name: ZSTRING)
		local
			found: BOOLEAN
		do
			across Qualifier_list as list until found loop
				if name.ends_with (list.item) then
					name.remove_tail (list.item.count)
					found := True
				end
			end
			if found then
				remove_qualifiers (name) -- recurse
			else
				name.prune_all_trailing ('-')
			end
		end

feature {NONE} -- Constants

	Qualifier_list: EL_ZSTRING_LIST
		once
			Result := "Bold, Italic, Oblique, Regular"
		end

end
