note
	description: "Summary description for {EL_LOCALE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-09 12:35:35 GMT (Monday 9th December 2013)"
	revision: "5"

class
	EL_LOCALE_ROUTINES

inherit
	EL_CROSS_PLATFORM [EL_LOCALE_ROUTINES_IMPL]

	EL_SINGLE_THREAD_ACCESS

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_PYXIS

create
	make

feature {NONE} -- Initialization

	make (a_default_language: like default_language)
		local
			refresh_xml: BOOLEAN
			xml_out: PLAIN_TEXT_FILE
			l_translations_path_list: like translations_path_list
			pyxis_in: EL_TEXT_IO_MEDIUM
			converter: EL_PYXIS_XML_TEXT_GENERATOR
			translations_node: EL_XPATH_ROOT_NODE_CONTEXT
			current_translations_modification_time: DATE_TIME
		do
			make_thread_access
			restrict_access -- synchronized
				make_platform
				default_language := a_default_language

				create translation_tables.make (7)
				l_translations_path_list := translations_path_list
				if Translations_file_path.exists then
					current_translations_modification_time := Translations_file_path.modification_time
					refresh_xml := across l_translations_path_list as file_path some
						file_path.item.modification_time > current_translations_modification_time
					end
				else
					refresh_xml := True
				end
				if refresh_xml then
					pyxis_in := merged_translations (l_translations_path_list)
					pyxis_in.open_read
					create xml_out.make_open_write (Translations_file_path.unicode)
					create converter.make
					converter.convert_stream (pyxis_in, xml_out)
					xml_out.close
				end
				create translations_node.make_from_file (Translations_file_path)

				internal_all_languages := languages_list (translations_node)
				if internal_all_languages.has (User_language_code) then
					language := User_language_code
				else
					language := default_language
				end
				create translations.make_from_root_node (language, translations_node)
			end_restriction
		end

feature -- Access

	translation alias "*" (key: EL_ASTRING): EL_ASTRING
			-- translation for current user language
		do
			restrict_access -- synchronized
				Result := translated_string (translations, key)
			end_restriction
		end

	translation_array (keys: INDEXABLE [STRING, INTEGER]): ARRAY [STRING]
			--
		local
			i, upper, lower: INTEGER
		do
			restrict_access -- synchronized
				lower := keys.index_set.lower
				upper := keys.index_set.upper
				create Result.make (1, keys.index_set.count)
				from i := lower until i > upper loop
					Result [i - lower + 1] := translation (keys [i])
					i := i + 1
				end
			end_restriction
		end

	translation_in (a_language: STRING; key: EL_ASTRING): EL_ASTRING
			-- translation for available localized language
		require
			has_language: has_language (a_language)
		local
			table: EL_TRANSLATION_TABLE
			translations_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			restrict_access -- synchronized
				if User_language_code ~ a_language then
					table := translations
				else
					translation_tables.search (a_language)
					if translation_tables.found then
						table := translation_tables.found_item
					else
						create translations_node.make_from_file (Translations_file_path)
						create table.make_from_root_node (a_language, translations_node)
						translation_tables.extend (table, a_language)
					end
				end
				Result := translated_string (table, key)
			end_restriction
		end

	word_count: INTEGER
		local
			token_string: EL_TOKENIZED_STRING
			table: EL_TRANSLATION_TABLE
		do
			restrict_access -- synchronized
				create token_string.make_empty
				table := translations
				from table.start until table.after loop
					token_string.wipe_out
					token_string.append_as_tokenized_lower (table.item_for_iteration)
					Result := Result + token_string.count
					table.forth
				end
			end_restriction
		end

	default_language: STRING

	language: STRING
		-- selected language code with translation, defaults to English if no
		-- translation available
		-- Possible values: en, de, fr..

	all_languages: like languages_list
		do
			restrict_access -- synchronized
				Result := internal_all_languages.twin
			end_restriction
		end

feature -- Status report

	has_language (a_language: STRING): BOOLEAN
		do
			restrict_access -- synchronized
				Result := internal_all_languages.has (a_language)
			end_restriction
		end

feature {NONE} -- Implementation

	merged_translations (a_translations_path_list: like translations_path_list): EL_TEXT_IO_MEDIUM
		local
			pyxis_source: STRING
			start_index: INTEGER
		do
			create Result.make_open_write (1024)
			-- Merge Pyxis files into one monolithic file
			across a_translations_path_list as pyxis_path loop
				pyxis_source := File_system.plain_text (pyxis_path.item)
				if pyxis_path.cursor_index = 1 then
					Result.put_string (pyxis_source)
				else
					-- Skip to first item
					start_index := pyxis_source.substring_index ("%Titem:", 1)
					if start_index > 0 then
						Result.put_string (pyxis_source.substring (start_index, pyxis_source.count))
					end
				end
				Result.put_new_line
			end
			Result.close
		end

	languages_list (a_translations_node: EL_XPATH_ROOT_NODE_CONTEXT): ARRAYED_LIST [STRING]
			--
		do
			create Result.make (5)
			Result.compare_objects
			across a_translations_node.context_list ("item[1]/translation") as node loop
				Result.extend (node.node.attributes ["lang"])
			end
		end

	translations_path_list: LIST [EL_FILE_PATH]
		local
			install_dir: EL_DIRECTORY
		do
			create install_dir.make_open_read (Translations_install_location)
			Result := install_dir.file_list ("pyx")
		end

	translated_string (table: like translations; key: EL_ASTRING): EL_ASTRING
		do
			table.search (key)
			if table.found then
				Result := table.found_item
			else
				Result := key + "*"
			end
		end

	translations: EL_TRANSLATION_TABLE

	internal_all_languages: like languages_list

	translation_tables: HASH_TABLE [EL_TRANSLATION_TABLE, STRING]

feature -- Constants

	Date: EL_LOCALE_DATE_ROUTINES
			--
		once
			create Result
		end

	User_language_code: STRING
			--
		once
			Result := implementation.user_language_code
		end

	Translations_file_path: EL_FILE_PATH
			--
		once
			Result := Execution.User_configuration_dir.joined_file_path ("localization.xml" )
		end

	Translations_install_location: EL_DIR_PATH
			--
		once
			Result := Execution.Application_installation_dir.joined_dir_path ("localization" )
		end
end
