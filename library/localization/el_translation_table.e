note
	description: "Summary description for {EL_LOCALIZATION_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TRANSLATION_TABLE

inherit
	HASH_TABLE [STRING, STRING]
		rename
			make as make_table
		redefine
			default_create
		end

	EL_BUILDABLE_FROM_XML
		rename
			make as make_buildable
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy, default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		local
			translations_info: EL_TRANSLATIONS_INFO
			xml_text, code: STRING
		do
			log.enter ("default_create")

			xml_text := File.plain_text (Execution_environment.Localization_translations_file_path)
			create translations_info.make_from_string (xml_text)
			make_table (translations_info.count)

			if translations_info.languages.has (Execution_environment.Language_code) then
				code := Execution_environment.Language_code
			else
				code := translations_info.default_language
			end

			create translation_for_id_xpath.make_from_string ("item/translation[@lang='$code']/text()")
			translation_for_id_xpath.replace_substring_all ("$code", code)
			log.put_line (translation_for_id_xpath)

			make_from_string (xml_text)
			log.exit
		end

feature {NONE} -- Build from XML

	add_translation
			--
		do
			create last_translation.make_empty
			last_key := node.to_string
			extend (last_translation, last_key)
		end

	set_last_translation_from_node
			--
		local
			text: STRING
		do
			text := node.to_string
			if text ~ once "$id" then
				last_translation.append (last_key)
			else
				last_translation.append (text)
			end
		end

	building_action_table: like building_actions
			--
		do
			create Result.make (<<
				["item/@id", agent add_translation],
				[translation_for_id_xpath, agent set_last_translation_from_node]
			>>)
		end

	Root_node_name: STRING = "translation-tables"

feature {NONE} -- Implementation

	last_key: STRING

	last_translation: STRING

	translation_for_id_xpath: STRING

end
