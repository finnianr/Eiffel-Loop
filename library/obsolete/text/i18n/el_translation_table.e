note
	description: "Summary description for {EL_LOCALIZATION_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_TRANSLATION_TABLE

inherit
	HASH_TABLE [STRING, STRING]
		rename
			make as make_table
		end

	EL_BUILDABLE_FROM_PYXIS
		undefine
			is_equal, copy
		redefine
			make
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			is_equal, copy
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			is_equal, copy
		end

	EL_MODULE_LOCALE
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

create
	make_from_file

feature {NONE} -- Initialization

	make
			--
		local
			translations_info: EL_TRANSLATIONS_INFO
			code: STRING
		do
			log.enter ("make")
			create translations_info
			make_table (translations_info.count)

			if translations_info.languages.has (Locale.User_language_code) then
				code := Locale.User_language_code
			else
				code := translations_info.default_language
			end

			create translation_for_id_xpath.make_from_string ("group/item/translation[@lang='$code']/text()")
			translation_for_id_xpath.replace_substring_all ("$code", code)
			log.put_line (translation_for_id_xpath)
			Precursor
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

	building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["group/item/@id", agent add_translation],
				[translation_for_id_xpath, agent set_last_translation_from_node]
			>>)
		end

	Root_node_name: STRING = "translation_tables"

feature {NONE} -- Implementation

	last_key: STRING

	last_translation: STRING

	translation_for_id_xpath: STRING

end
