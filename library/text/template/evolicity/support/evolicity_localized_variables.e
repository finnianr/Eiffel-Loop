note
	description: "[
		Helper class to translate variable text-values which have a localization translation id of the form
		"{evol.<variable-name>}" where `$<variable-name>' corresponds to a template substitution variable.
		
		`Variable_translation_keys' returns all localization identifiers which match that pattern.
		
		`translated_variables_tables' can be merged with `getter_function_table' in an Evolicity 
		context.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-26 14:12:42 GMT (Sunday 26th September 2021)"
	revision: "5"

deferred class
	EVOLICITY_LOCALIZED_VARIABLES

inherit
	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_EVOLICITY_TEMPLATES

feature {NONE} -- Evolicity fields

	translated_variables_table: EVOLICITY_OBJECT_TABLE [FUNCTION [ANY]]
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