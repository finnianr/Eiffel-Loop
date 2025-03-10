note
	description: "[
		Reflective initialization of localized string fields based on deferred `Locale'
		conforming to ${EL_DEFERRED_LOCALE_I}
	]"
	descendants: "See end of class"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-03 8:46:58 GMT (Monday 3rd March 2025)"
	revision: "44"

deferred class
	EL_REFLECTIVE_LOCALE_TEXTS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
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

	EL_CHARACTER_8_CONSTANTS; EL_LOCALE_CONSTANTS

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
			value: ANY; lower_case, upper_case, title_case, paragraph: like None
			text_case: NATURAL_8
		do
			Precursor
			lower_case := lower_case_texts; title_case := title_case_texts; upper_case := upper_case_texts
			paragraph := paragraph_texts
			if attached new_english_table as eng_table then
				across field_table as field loop
					if attached {EL_REFLECTED_REFERENCE [ANY]} field.item as ref_field then
						value := ref_field.value (current_reflective)
						if value_in_set (value, lower_case) then
							text_case := {EL_CASE}.Lower
						elseif value_in_set (value, upper_case) then
							text_case := {EL_CASE}.Upper
						elseif value_in_set (value, title_case) then
							text_case := {EL_CASE}.Proper
						else
							text_case := {EL_CASE}.Sentence -- The default is first letter capitalized
						end
						if ref_field.type_id = Class_id.EL_QUANTITY_TEMPLATE then
							fill_quantity_template (ref_field, eng_table)
						else
							set_field (ref_field, text_case, eng_table)
						end
						if value_in_set (value, paragraph) and then attached {EL_REFLECTED_ZSTRING} ref_field as zstr then
							set_as_paragraph (zstr.value (Current))
						end
					else
						set_field (field.item, {EL_CASE}.Lower, eng_table)
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

	missing_keys_list: detachable EL_ZSTRING_LIST note option: transient attribute end
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
		local
			table: EL_IMMUTABLE_UTF_8_TABLE
		do
			create table.make ({EL_TABLE_FORMAT}.Indented_eiffel, english_table)
			from Result := True; table.start until table.after or not Result loop
				Result := field_table.has_general (table.key_for_iteration)
				table.forth
			end
		end

	valid_special_keys: BOOLEAN
		-- check that all computed translation keys are valid
		-- used for special cases where translated fields are not used
		do
			Result := True
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

	paragraph_texts: like None
		-- English key texts of type `ZSTRING' that should be canonically spaced
		do
			Result := None
		ensure
			zstring_types: across Result as str all attached {ZSTRING} str.item end
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

	new_english_table: EL_IMMUTABLE_UTF_8_TABLE
		local
			text_table: like english_table; substituted_text: ZSTRING
		do
			text_table := english_table
			if text_table.has ('%%') and then
				across Substitution_table as table some text_table.has_substring (table.item) end
			then
				create substituted_text.make (text_table.count + text_table.occurrences ('%%') * 2)
				substituted_text.append_string_general (text_table)
				across Substitution_table as table loop
					substituted_text.replace_substring_all (table.key, table.item)
				end
				create Result.make_indented_eiffel (substituted_text)
			else
				create Result.make_indented_eiffel (text_table)
			end
		end

	new_quantity_table (text: ZSTRING): EL_ZSTRING_TABLE
		do
			Result := text
		ensure
			valid_keys: across Result as name all Quantifier_names.has (name.key) end
		end

feature {NONE} -- Implementation

	all_texts: like None
		do
			Result := text_list.to_array
		end

	extend_missing_keys (key: ZSTRING)
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
			partial_key: ZSTRING; quantity_table: like new_quantity_table
			quantity: INTEGER
		do
			if attached {EL_QUANTITY_TEMPLATE} field.value (current_reflective) as template
				and then eng_table.has_immutable_key (field.name)
			then
				quantity_table := new_quantity_table (eng_table.found_item)
				partial_key := translation_key (field.name, {EL_CASE}.Lower, True)
				across Quantifier_names as name loop
					if quantity_table.has_key (name.item) then
						quantity := name.cursor_index - 1
						if locale.english_only then
							template.put_template (quantity_table.found_item, quantity)

						elseif attached (partial_key + Number_suffix [quantity]) as key then
							if attached locale.possible_translation (key) as translation then
								template.put_template (translation, quantity)
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
		do
			Result := new_line.joined (precursor_lines, lines)
		end

	set_as_paragraph (str: ZSTRING)
		do
			if attached str.lines as lines then
				str.wipe_out
				across lines as line loop
					if line.item.is_empty then
						str.append_character ('%N')
					else
						if str.count > 0 then
							str.append_character (' ')
						end
						str.append (line.item)
					end
				end
			end
		end

	set_field (field: EL_REFLECTED_FIELD; text_case: NATURAL_8; eng_table: like new_english_table)
		local
			key: ZSTRING; text_differs: BOOLEAN
		do
			text_differs := eng_table.has_immutable_key (field.name)
			key := translation_key (field.name, text_case, text_differs)
			if text_differs and then Locale.english_only then
				locale.set_next_translation (eng_table.found_item)
			end
			if attached locale.possible_translation (key) as translation then
				if field.is_type (Class_id.ZSTRING) then
					field.set (Current, translation)
				else
					field.set_from_string (Current, translation)
				end
			else
				extend_missing_keys (key.twin)
			end
		end

	translation_key (name: IMMUTABLE_STRING_8; text_case: NATURAL_8; text_differs: BOOLEAN): ZSTRING
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
					when {EL_CASE}.Sentence then
						Result.put (Result.item (1).as_upper, 1)
					when {EL_CASE}.Upper then
						Result.to_upper
					when {EL_CASE}.Proper then
						Result.to_proper
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

	Empty_table: STRING = ""

	Key_buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

	None: ARRAY [ANY]
		once
			create Result.make_empty
		end

	Substitution_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (3)
			Result ["%%S"] := "%S"
			Result ["%%T"] := "%T"
		end

note
	descendants: "[
			EL_REFLECTIVE_LOCALE_TEXTS*
				${EL_PASSPHRASE_ATTRIBUTES}
				${EL_DAY_OF_WEEK_TEXTS}
				${EL_CURRENCY_TEXTS}
				${EL_MONTH_TEXTS}
				${EL_PHRASE_TEXTS}
				${EL_PASSPHRASE_TEXTS}
				${EL_UNINSTALL_TEXTS}
				${EL_WORD_TEXTS}
	]"
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
			
		Texts that span multiple lines can be coalesced into one paragraph by redefining the function
		`paragraph_texts' and listing the field in the result array.

		If the default English text differs from the translation key it can be entered in the text table
		**english_table** formatted as in the following example:

			install_application:
				Install My Ching application
			uninstall_application:
				Uninstall %S application

		Note the use of `%S' as a ${EL_ZSTRING} template placeholder. This will be translated to
		the `#' character.

		The lookup keys for the localization files will be hypenated and enclosed with curly braces as in
		this example:

			{install-application}
			{uninstall-application}

		See ${EL_UNINSTALL_TEXTS} as an example.
	]"
end