note
	description: "Unix implementation of ${EL_FONT_FAMILIES_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 19:16:37 GMT (Friday 13th September 2024)"
	revision: "5"

class
	EL_FONT_FAMILIES_IMP

inherit
	EL_FONT_FAMILIES_I
		undefine
			copy, default_create
		end

	EV_ENVIRONMENT
		export
			{NONE} all
		redefine
			initialize
		end

	EL_MODULE_FILE_SYSTEM


feature {NONE} -- Initialization

	initialize
		do
			Precursor
			property_table := new_property_table
		end

feature {NONE} -- Implementation

	family_char_set (family: STRING_32): INTEGER
		do
			-- Windows only
		end

	is_true_type (true_type_set: EL_HASH_SET [ZSTRING]; family: STRING_32): BOOLEAN
		do
			across String_scope as scope loop
				if attached scope.copied_item (family) as name then
					name.prune_all (' ')
					Result := true_type_set.has (name)
				end
			end
		end

	new_font_families_map: EL_ARRAYED_MAP_LIST [STRING_32, INTEGER]
		-- map family to character set
		do
			if attached {EV_APPLICATION_IMP} implementation.application_i as app_imp then
				create Result.make_from_keys (app_imp.font_names_on_system, agent family_char_set)
				Result.sort_by_key (True)
			else
				create Result.make (0)
			end
		end

	new_true_type_set: EL_HASH_SET [ZSTRING]
		do
			if attached File_system.files_with_extension ("/usr/share/fonts/truetype", "ttf", True) as true_type_list then
				create Result.make_equal (true_type_list.count)
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