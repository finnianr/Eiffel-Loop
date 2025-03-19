note
	description: "[
		Helper class to translate variable text-values which have a localization translation id of the form
		"{evol.<variable-name>}" where `$<variable-name>' corresponds to a template substitution variable.
		
		`Variable_translation_keys' returns all localization identifiers which match that pattern.
		
		`translated_variables_tables' can be merged with `getter_function_table' in an Evolicity 
		context.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:58 GMT (Tuesday 18th March 2025)"
	revision: "9"

deferred class
	EVC_LOCALIZED_VARIABLES

inherit
	EL_MODULE_DEFERRED_LOCALE

	EVC_SHARED_TEMPLATES

feature {NONE} -- Evolicity fields

	translated_variables_table: EVC_FUNCTION_TABLE
		-- table of variables which have a localization translation of the form "{$<variable-name>}"
		local
			translation_key_table: EL_ZSTRING_TABLE
		do
			translation_key_table := Evolicity_templates.new_translation_key_table
			create Result.make_equal (translation_key_table.count)
			across translation_key_table as variable loop
				Result [variable.key] := agent translation (variable.item)
			end
		end

feature {NONE} -- Implementation

	translation (key: ZSTRING): ZSTRING
		do
			Result := language_locale.translation (key)
		end

	language_locale: EL_DEFERRED_LOCALE_I
		do
			Result := Locale.in (language)
		end

	language: STRING
		deferred
		end

end