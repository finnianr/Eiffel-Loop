note
	description: "[
		Reflective initialization of localized string fields based on deferred `Locale' conforming to [$source EL_DEFERRED_LOCALE_I]
	]"
	notes: "[
		Inherit this class and then string fields will be initialized with a localized value. See library [./library/i18n.html i18n.ecf]
		By using the library, it over-rides the deferred Locale found in the [./library/base/base.text.html base.ecf#text cluster].

		By default field values are set to the name of the field with underscores changed to spaces and the first letter capitalized.
		Any trailing underscore character to differentiate from an Eiffel keyword is removed.

			install_application -> "Install application"
			
		If the default English text differs from this then it can be entered in the text table `english_table' formatted as follows:
		
			install_application:
				Install My Ching application
			uninstall_application:
				Uninstall %S application
				
		Note the use of `%S' as a [$source EL_ZSTRING] template placeholder. This will be translated to the `#' character.
				
		The lookup keys for the localization files will be hypenated and enclosed with curly braces as in this example:
		
			{install-application}
			{uninstall-application}
			
		See [$source EL_UNINSTALL_TEXTS] as an example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-10 11:02:34 GMT (Monday 10th May 2021)"
	revision: "7"

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
		redefine
			initialize_fields
		end

	EL_MODULE_DEFERRED_LOCALE
		rename
			Locale as Default_locale
		end

	EL_MODULE_TUPLE

feature {NONE} -- Initialization

	initialize_fields
		local
			l_table: like new_english_table
			key: ZSTRING
		do
			l_table := new_english_table
			create key.make (20)
			across field_table as field loop
				key.wipe_out
				if l_table.has_key (field.key) then
					key.append_character ('{')
					key.append_string_general (field.key)
					key.prune_all_trailing ('_') -- in case of keyword differentiation
					key.append_character ('}')
					key.replace_character ('_', '-')
					locale.set_next_translation (l_table.found_item)
				else
					key.append_string_general (field.key)
					key.prune_all_trailing ('_')
					key.replace_character ('_', ' ')
					inspect case
						when Case_first_upper then
							key.put (key.unicode_item (1).as_upper, 1)
						when Case_upper then
							key.to_upper
						when Case_proper then
							key.to_proper_case
					else
						-- lower case
					end
				end
				field.item.set_from_string (current_reflective, locale * key)
			end
		end

	make
		do
			make_with_locale (Default_locale)
		end

	make_with_locale (a_locale: like locale)
		do
			locale := a_locale
			make_default
		end

feature {NONE} -- Implementation

	case: INTEGER
		-- English word case modification for field names
		deferred
		ensure
			renamed_as_case_constant: Case_lower <= Result and Result <= Case_first_upper
		end

	english_table: READABLE_STRING_GENERAL
		-- description of attributes
		deferred
		ensure
			renamed_as_empty_table: Result.is_empty implies Result = Empty_table
		end

	joined (precursor_lines, lines: STRING): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := precursor_lines + s.character_string ('%N') + lines
		end

	new_english_table: EL_ZSTRING_TABLE
		local
			text: ZSTRING
		do
			create text.make_from_general (english_table)
			text.replace_substring_all (Substitution.string, Substitution.character)
			create Result.make (text)
		ensure
			valid_table: across Result as table all field_table.has (table.key) end
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

	Substitution: TUPLE [string, character: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "%%S, %S")
		end

end