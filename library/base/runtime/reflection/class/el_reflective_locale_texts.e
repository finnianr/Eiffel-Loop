note
	description: "[
		Reflective initialization of localized string fields based on deferred `Locale' conforming to [$source EL_DEFERRED_LOCALE_I]
	]"
	notes: "[
		Inherit this class and then string fields will be initialized with a localized value. See library [./library/i18n.html i18n.ecf]

		By default field values are set to the name of the field with underscores changed to spaces and the first letter capitalized
		
			install_application -> "Install application"
			
		If the default English text differs from this then it can be entered in the text table `english_table' formatted as follows:
		
			install_application:
				Install My Ching application
			uninstall_application:
				Uninstall My Ching application
				
		The lookup keys for the localization files will be hypenated and enclosed with curly braces as in this example:
		
			{install-application}
			{uninstall-application}

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-18 9:10:20 GMT (Friday 18th September 2020)"
	revision: "1"

deferred class
	EL_REFLECTIVE_LOCALE_TEXTS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default,
			make_default as make
		export
			{NONE} all
			{ANY} print_fields
		redefine
			initialize_fields
		end

	EL_MODULE_DEFERRED_LOCALE

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
					key.append_character ('}')
					key.replace_character ('_', '-')
					Locale.set_next_translation (l_table.found_item)
				else
					key.append_string_general (field.key)
					key.replace_character ('_', ' ')
					key.put (key.unicode_item (1).as_upper, 1)
				end
				field.item.set_from_string (current_reflective, Locale * key)
			end
		end

feature {NONE} -- Implementation

	english_table: READABLE_STRING_GENERAL
		-- description of attributes
		deferred
		end

	new_english_table: EL_DESCRIPTION_TABLE
		local
			text: ZSTRING
		do
			create text.make_from_general (english_table)
			text.replace_substring_all (Substitution.string, Substitution.character)
			create Result.make (text)
		ensure
			valid_table: across Result as table all field_table.has (table.key) end
		end

feature {NONE} -- Constants

	Substitution: TUPLE [string, character:ZSTRING]
		once
			create Result
			Tuple.fill (Result, "%%S, %S")
		end
end