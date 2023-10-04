note
	description: "[
		Routines to access Windows font information in registry
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	EL_FONT_REGISTRY_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_MODULE_WIN_REGISTRY; EL_MODULE_REG_KEY

feature -- Access

	new_true_type_font_set: EL_HASH_SET [ZSTRING]
		local
			name, name_part: ZSTRING; name_split: EL_SPLIT_ZSTRING_ON_STRING
		do
			create Result.make (100)
			across Win_registry.value_names (HKLM_fonts) as list loop
				name := list.name
				if name.ends_with (True_type_suffix) then
					name.remove_tail (True_type_suffix.count)
					name.right_adjust
					if name.has_substring (Ampersand_string) then
						create name_split.make (name, Ampersand_string)
						across name_split as split loop
							name_part := split.item
							remove_qualifiers (name_part)
							Result.put_copy (name_part)
						end
					else
						remove_qualifiers (name)
						Result.put (name)
					end
				end
			end
		end

feature -- Constants

	Substitute_fonts: HASH_TABLE [ZSTRING, STRING_32]
		local
			name: STRING_32
		once
			create Result.make_equal (30)
			across Win_registry.string_list (HKLM_font_substitutes) as list loop
				name := list.item.name.substring_to (',', default_pointer)
				Result [name] := list.item.value.substring_to (',', default_pointer)
			end
		end

	Valid_font_types: EL_STRING_8_LIST
		once
			Result := "fon, fnt, ttf, ttc, fot, otf, mmm, pfb, pfm"
		end

feature {NONE} -- Implementation

	remove_qualifiers (name: ZSTRING)
		local
			removed: BOOLEAN; word: ZSTRING
		do
			across Qualifier_word_list as list until removed loop
				word := list.item
				if name.ends_with (word) and then name.count > word.count then
					name.remove_tail (word.count); name.right_adjust
					removed := True
				end
			end
			if removed then
				remove_qualifiers (name) -- Recurse
			else
				name.trim
			end
		end

feature {NONE} -- Constants

	Ampersand_string: ZSTRING
		once
			Result := " & "
		end

	HKLM_font_substitutes: DIR_PATH
		once
			Result := Reg_key.Windows_nt.current_version ("FontSubstitutes")
		end

	HKLM_fonts: DIR_PATH
		once
			Result := Reg_key.Windows_nt.current_version ("Fonts")
		end

	Qualifier_word_list: EL_ZSTRING_LIST
		once
			Result := "Bold, Italic, Oblique, Regular, Semibold"
		end

	True_type_suffix: ZSTRING
		once
			Result := "(TrueType)"
		end

end
