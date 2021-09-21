note
	description: "[
		Helper class to translate variable text-values which have a localization translation id of the form
		"{$<variable-name>}" where `$<variable-name>' corresponds to a template substitution variable.
		
		`Variable_translation_keys' returns all localization identifiers which match that pattern.
		
		`translated_variables_tables' can be merged with `getter_function_table' in an Evolicity 
		context.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-21 8:14:02 GMT (Tuesday 21st September 2021)"
	revision: "3"

deferred class
	EVOLICITY_LOCALIZED_VARIABLES

inherit
	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_PATTERN

feature {NONE} -- Evolicity fields

	translated_variables_table: EVOLICITY_OBJECT_TABLE [FUNCTION [ANY]]
		-- table of variables which have a localization translation of the form "{$<variable-name>}"
		do
			create Result.make_equal (Variable_translation_keys.count)
			across Variable_translation_keys as variable loop
				Result [variable.item.name] := agent translation (variable.item.translation_key)
			end
		end

feature {NONE} -- Implementation

	translation (key: ZSTRING): ZSTRING
		do
			Result := language_locale.translation (key)
		end

	language_locale: EL_DEFERRED_LOCALE_I
		deferred
		end

	language: STRING
		deferred
		end

feature {NONE} -- Constants

	Variable_signature: ZSTRING
		once
			Result := "{$"
		end

	Variable_translation_keys: ARRAYED_LIST [TUPLE [name, translation_key: ZSTRING]]
		-- list of variable names corresponding to a localization ID of the form "{$<variable-name>}"
		local
			l_key, name: ZSTRING
		once
			create Result.make (20)
			across Locale.translation_keys as key loop
				l_key := key.item
				if l_key.starts_with (Variable_signature) and then l_key [l_key.count] = '}' then
					name := l_key.twin; name.remove_head (2); name.remove_tail (1)
					if Pattern.is_match (name, Pattern.c_identifier) then
						Result.extend ([name, l_key])
					end
				end
			end
		end

end