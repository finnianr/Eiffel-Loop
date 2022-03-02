note
	description: "[
		Reflective initialization of localized string fields based on deferred `Locale'
		conforming to [$source EL_DEFERRED_LOCALE_I]
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-02 10:29:47 GMT (Wednesday 2nd March 2022)"
	revision: "22"

deferred class
	EL_REFLECTIVE_LOCALE_TEXTS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		export
			{NONE} all
			{ANY} print_fields
			{EL_REFLECTION_HANDLER} field_table
		redefine
			initialize_fields
		end

	EL_MODULE_DEFERRED_LOCALE
		rename
			Locale as Default_locale
		end

	EL_MODULE_TUPLE

	EL_SHARED_CLASS_ID

	EL_LOCALE_CONSTANTS

feature {EL_MODULE_EIFFEL} -- Initialization

	make
		do
			make_with_locale (Default_locale)
		end

	make_with_locale (a_locale: like locale)
		do
			locale := a_locale
			make_default
		end

	make_english
		local
			locale_en: EL_DEFERRED_LOCALE_IMP
		do
			create locale_en.make
			make_with_locale (locale_en)
		end

feature {NONE} -- Initialization

	initialize_fields
		require else
			valid_english_table: valid_english_table
		local
			value: ANY; lower_case, upper_case, title_case: like None
			text_case: INTEGER
		do
			Precursor
			lower_case := lower_case_texts; title_case := title_case_texts; upper_case := upper_case_texts
			if attached new_english_table as eng_table then
				across field_table as field loop
					if attached {EL_REFLECTED_REFERENCE [ANY]} field.item as ref_field then
						value := ref_field.value (current_reflective)
						if value_in_set (value, lower_case) then
							text_case := Case_lower
						elseif value_in_set (value, upper_case) then
							text_case := Case_upper
						elseif value_in_set (value, title_case) then
							text_case := Case_proper
						else
							text_case := Case_first_upper -- The default is first letter capitalized
						end
						if ref_field.type_id = Class_id.EL_QUANTITY_TEMPLATE then
							fill_quantity_template (ref_field, eng_table)
						else
							set_field (ref_field, text_case, eng_table)
						end
					else
						set_field (field.item, Case_lower, eng_table)
					end
				end
			end
		ensure then
			no_missing_keys: not attached missing_keys_list
		end

feature -- Access

	language: STRING
		do
			Result := locale.language
		end

	missing_keys_list: detachable ARRAYED_LIST [ZSTRING] note option: transient attribute end
		-- list of keys not found

	text_list: EL_ZSTRING_LIST
		-- list of all texts
		do
			create Result.make (field_table.count)
			across field_table as field loop
				if attached {EL_REFLECTED_ZSTRING} field.item as l_field then
					Result.extend (l_field.value (current_reflective))
				end
			end
		end

feature -- Contract Support

	valid_english_table: BOOLEAN
		do
			Result := across new_english_table as table all field_table.has (table.key) end
		end

feature {NONE} -- Deferred

	english_table: READABLE_STRING_GENERAL
		-- description of attributes
		deferred
		ensure
			renamed_as_empty_table: Result.is_empty implies Result = Empty_table
			names_aligned_with_start_of_line: Result.count > 0 implies (Result.has ('%N') and then valid_first_name (Result))
		end

feature {NONE} -- Case group sets

	lower_case_texts: like None
		-- English key texts that are entirely lower case
		do
			Result := None
		end

	title_case_texts: like None
		-- English key texts that are entirely title case (First letter of each word capatilized)
		do
			Result := None
		end

	upper_case_texts: like None
		-- English key texts that are entirely upper case
		do
			Result := None
		end

feature {NONE} -- Factory

	new_english_table: EL_ZSTRING_TABLE
		do
			create Result.make (english_table)
			across Result as table loop
				if table.item.has ('%%') then
					across Substitution_table as substitution loop
						table.item.replace_substring_all (substitution.key, Substitution.item)
					end
				end
			end
		ensure
			all_keys_match_a_field_name: across Result as table all field_table.has (table.key) end
		end

	new_quantity_table (text: ZSTRING): EL_ZSTRING_TABLE
		do
			create Result.make (text)
		ensure
			valid_keys: across Result as name all Quantifier_names.has (name.key) end
		end

feature {NONE} -- Implementation

	all_texts: like None
		do
			Result := text_list.to_array
		end

	extend_missing_keys (key: STRING)
		do
			if attached missing_keys_list as list then
				list.extend (key)
			else
				create missing_keys_list.make_from_array (<< key >>)
			end
		end

	fill_quantity_template (field: EL_REFLECTED_FIELD; eng_table: like new_english_table)
		require
			valid_field: field.type_id = Class_id.EL_QUANTITY_TEMPLATE
		local
			key, partial_key: ZSTRING; quantity_table: like new_quantity_table
			quantity: INTEGER
		do
			if attached {EL_QUANTITY_TEMPLATE} field.value (current_reflective) as template
				and then eng_table.has_key (field.name)
			then
				quantity_table := new_quantity_table (eng_table.found_item)
				partial_key := translation_key (field.name, Case_lower, True)
				across Quantifier_names as name loop
					if quantity_table.has_key (name.item) then
						quantity := name.cursor_index - 1
						if locale.english_only then
							template.put_template (quantity_table.found_item, quantity)
						else
							key := partial_key + Number_suffix [quantity]
							if locale.has_key (key) then
								template.put_template (locale * key, quantity)
							else
								extend_missing_keys (key)
							end
						end
					end
				end
			else
				extend_missing_keys (field.name)
			end
		end

	joined (precursor_lines, lines: STRING): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := precursor_lines + s.character_string ('%N') + lines
		end

	set_field (field: EL_REFLECTED_FIELD; text_case: INTEGER; eng_table: like new_english_table)
		local
			key: ZSTRING; text_differs: BOOLEAN
		do
			text_differs := eng_table.has_key (field.name)
			key := translation_key (field.name, text_case, text_differs)
			if text_differs and then Locale.english_only then
				locale.set_next_translation (eng_table.found_item)
			end
			if locale.has_key (key) then
				field.set_from_string (Current, locale * key)
			else
				extend_missing_keys (key.twin)
			end
		end

	translation_key (name: STRING; text_case: INTEGER; text_differs: BOOLEAN): ZSTRING
		do
			Result := Key_buffer.copied_general (name)
			Result.prune_all_trailing ('_') -- in case of keyword differentiation
			if text_differs then
				-- Text differs from key
				Result.enclose ('{', '}')
			else
				-- Text is identical to the key
				Result.replace_character ('_', ' ')
				inspect text_case
					when Case_first_upper then
						Result.put (Result.item (1).as_upper, 1)
					when Case_upper then
						Result.to_upper
					when Case_proper then
						Result.to_proper_case
				else
					-- all lower case
				end
			end
		end

	valid_first_name (lines: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if first line ends with ':' and does not start with white space
		require
			has_new_line: lines.has ('%N')
		local
			first_line: ZSTRING
		do
			create first_line.make_empty
			first_line.append_substring_general (lines, 1, lines.index_of ('%N', 1) - 1)
			if first_line.count > 1 and then first_line [first_line.count] = ':' then
				Result := not first_line.is_space_item (1)
			end
		end

	value_in_set (value: ANY; set: like none): BOOLEAN
		require
			comparing_references: not set.object_comparison
		do
			if set.count > 0 and then set [1].same_type (value) then
				Result := set.has (value)
			end
		end

feature {NONE} -- Internal attributes

	locale: EL_DEFERRED_LOCALE_I note option: transient attribute end

feature {NONE} -- Constants

	Case_first_upper: INTEGER = 4
		-- first letter only is upper cased

	Case_lower: INTEGER = 1

	Case_proper: INTEGER = 3

	Case_upper: INTEGER = 2

	Empty_table: STRING = ""

	Key_buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

	None: ARRAY [ANY]
		once
			create Result.make_empty
		end

	Substitution_table: EL_HASH_TABLE [ZSTRING, ZSTRING]
		once
			create Result.make_size (2)
			Result ["%%S"] := "%S"
			Result ["%%T"] := "%T"
		end

note
	notes: "[
		Inherit this class and then string fields will be initialized with a localized value. 
		See library [./library/i18n.html i18n.ecf] By using the library, it over-rides the deferred Locale
		found in the [./library/base/base.text.html base.ecf#text cluster].

		By default field values are set to the name of the field with underscores changed to spaces and the
		first letter capitalized. Any trailing underscore character to differentiate from an Eiffel keyword
		is removed.

			install_application -> "Install application"

		Some texts can be placed in a different case group  by redefining one of the array functions and listing
		the field in the Result array.

			lower_case_texts
			upper_case_texts
			title_case_texts

		If the default English text differs from the translation key it can be entered in the text table
		**english_table** formatted as in the following example:

			install_application:
				Install My Ching application
			uninstall_application:
				Uninstall %S application

		Note the use of `%S' as a [$source EL_ZSTRING] template placeholder. This will be translated to
		the `#' character.

		The lookup keys for the localization files will be hypenated and enclosed with curly braces as in
		this example:

			{install-application}
			{uninstall-application}

		See [$source EL_UNINSTALL_TEXTS] as an example.
	]"

end