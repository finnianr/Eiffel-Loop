note
	description: "Summary description for {EL_LOCALE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-28 13:18:18 GMT (Monday 28th December 2015)"
	revision: "9"

class
	EL_LOCALE_ROUTINES

inherit
	EL_CROSS_PLATFORM [EL_LOCALE_ROUTINES_IMPL]
		redefine
			make_default
		end

	EL_SINGLE_THREAD_ACCESS
		redefine
			make_default
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_ONCE_STRINGS

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_CROSS_PLATFORM}
			Precursor {EL_SINGLE_THREAD_ACCESS}
		end

 	make (a_language: STRING; a_default_language: like default_language)
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			make_default
			restrict_access
				default_language := a_default_language
				create date_text
				create root_node.make_from_file (XML_dir + "localization.xml")

				set_all_languages (root_node)
				if internal_all_languages.has (a_language) then
					language := a_language
				else
					language := default_language
				end
				create translations.make_from_root_node (language, root_node)
			end_restriction
		end

feature -- Access

	date_text: EL_LOCALE_DATE_TEXT

	translation alias "*" (general_key: READABLE_STRING_GENERAL): ZSTRING
			-- translation for source code string in current user language
		do
			restrict_access
				Result := translated_string (translations, key (general_key))
			end_restriction
		end

	quantity_translation (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): ZSTRING
			-- translation with adjustments according to value of quanity
			-- keys have
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		local
			substitutions: ARRAY [like translation_template.Type_name_value_pair]
		do
			create substitutions.make_empty
			Result := quantity_translation_extra (partial_key, quantity, substitutions)
		end

	quantity_translation_extra (
		partial_key: READABLE_STRING_GENERAL; quantity: INTEGER
		substitutions: ARRAY [like translation_template.Type_name_value_pair]
	): ZSTRING
			-- translation with adjustments according to value of quanity
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		local
			template: like translation_template
		do
			restrict_access
				template := translation_template (quantity_key (partial_key, quantity))
				template.disable_strict
				template.set_variables_from_array (substitutions)
				if template.has_variable (Variable_quantity) then
					template.set_variable (Variable_quantity, quantity)
				end
				Result := template.substituted
			end_restriction
		end

  	substituted (template_key: READABLE_STRING_GENERAL; inserts: TUPLE): ZSTRING
  		do
  			Result := translation (template_key).substituted_tuple (inserts)
  		end

	translation_array (general_keys: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]): ARRAY [ZSTRING]
			--
		local
			i, upper, lower: INTEGER
		do
			restrict_access -- synchronized
				lower := general_keys.index_set.lower
				upper := general_keys.index_set.upper
				create Result.make (1, general_keys.index_set.count)
				from i := lower until i > upper loop
					Result [i - lower + 1] := translated_string (translations, key (general_keys [i]))
					i := i + 1
				end
			end_restriction
		end

	translation_keys: ARRAY [ZSTRING]
		do
			restrict_access -- synchronized
				Result := translations.current_keys
			end_restriction
		end

	default_language: STRING

	language: STRING
		-- selected language code with translation, defaults to English if no
		-- translation available
		-- Possible values: en, de, fr..

	all_languages: ARRAYED_LIST [STRING]
		do
			restrict_access -- synchronized
				Result := internal_all_languages.twin
			end_restriction
		end

feature -- Status report

	has_translation (a_language: STRING): BOOLEAN
		do
			restrict_access -- synchronized
				Result := internal_all_languages.has (a_language)
			end_restriction
		end

	is_valid_quantity_key (general_key: READABLE_STRING_GENERAL; quantity: INTEGER): BOOLEAN
		do
			restrict_access
				Result := translations.has (quantity_key (general_key, quantity))
			end_restriction
		end

feature {NONE} -- Implementation

	key (general_key: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} general_key as z_key then
				Result := z_key
			else
				Result := empty_once_string
				Result.append_string_general (general_key)
			end
		end

	quantity_key (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): ZSTRING
			-- complete partial_key by appending .zero .singular OR .plural
		do
			Result := empty_once_string
			Result.append_string_general (partial_key)
			if quantity = 1 then
				Result.append_string (Dot_singular)
			else
				if quantity = 0 then
					Result.append_string (Dot_zero)
					if not translations.has (Result) then
						Result.remove_tail (Dot_zero.count)
						Result.append_string (Dot_plural)
					end
				else
					Result.append_string (Dot_plural)
				end
			end
		end

	set_all_languages (root_node: EL_XPATH_ROOT_NODE_CONTEXT)
			--
		local
			list: EL_XPATH_NODE_CONTEXT_LIST
		do
			list := root_node.context_list ("item[1]/translation")
			create internal_all_languages.make (list.count)
			internal_all_languages.compare_objects
			across list as l_translation loop
				internal_all_languages.extend (l_translation.node.attributes.string_8 ("lang"))
			end
		end

	translated_string (table: like translations; a_key: ZSTRING): ZSTRING
		do
			table.search (a_key)
			if table.found then
				Result := table.found_item
			else
				Result := a_key + "*"
			end
		end

	translation_template (a_key: ZSTRING): EL_SUBSTITUTION_TEMPLATE [ZSTRING]
		do
			Result := translated_string (translations, a_key)
		end

	translations: EL_TRANSLATION_TABLE

	internal_all_languages: like all_languages

feature -- Constants

	User_language_code: STRING
			--
		once
			Result := implementation.user_language_code
		end

feature {NONE} -- Constants

	XML_dir: EL_DIR_PATH
			--
		once
			Result := Directory.Application_installation
		end

	Variable_quantity: STRING = "QUANTITY"

	Dot_singular: ZSTRING
		once
			Result := ".singular"
		end

	Dot_plural: ZSTRING
		once
			Result := ".plural"
		end

	Dot_zero: ZSTRING
		once
			Result := ".zero"
		end

end
