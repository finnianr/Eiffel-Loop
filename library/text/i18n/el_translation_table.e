note
	description: "Summary description for {EL_LOCALIZATION_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-21 11:19:23 GMT (Monday 21st December 2015)"
	revision: "9"

class
	EL_TRANSLATION_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ZSTRING]
		rename
			make as make_from_array,
			put as put_table
		end

	EL_BUILDABLE_FROM_PYXIS
		undefine
			is_equal, copy, default_create
		redefine
			make_default, building_action_table
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy, default_create
		end

create
	make, make_from_root_node, make_from_pyxis_source, make_from_pyxis

feature {NONE} -- Initialization

	make_default
		do
			create last_id.make_empty
			make_equal (60)
			Precursor
		end

	make (a_language: STRING)
		do
			language := a_language
			make_default
		end

	make_from_pyxis (a_language: STRING; pyxis_file_path: EL_FILE_PATH)
		do
			make (a_language)
			refresh_building_actions
			build_from_file (pyxis_file_path)
		end

	make_from_pyxis_source (a_language: STRING; pyxis_source: STRING)
		do
			make (a_language)
			refresh_building_actions
			build_from_string (pyxis_source)
		end

	make_from_root_node (a_language: STRING; root_node: EL_XPATH_ROOT_NODE_CONTEXT)
			-- build from xml
		require
			document_has_translation: document_has_translation (a_language, root_node)
		local
			translations: EL_XPATH_NODE_CONTEXT_LIST
		do
			log.enter_with_args ("make_from_root_node", << a_language >>)
			make (a_language)
			translations := root_node.context_list (Xpath_translations.substituted_tuple ([language]).to_unicode)
			accommodate (translations.count)
			across translations as translation loop
				put (translation.node.string_value, translation.node.string_at_xpath (Xpath_parent_id))
			end
			log.exit
		end

feature -- Access

	language: STRING

feature -- Contract Support

	document_has_translation (a_language: STRING; root_node: EL_XPATH_ROOT_NODE_CONTEXT): BOOLEAN
		do
			Result := root_node.is_xpath (Xpath_language_available.substituted_tuple ([a_language]).to_unicode)
		end

feature {NONE} -- Implementation

	put (a_translation, translation_id: ZSTRING)
		local
			translation: ZSTRING
		do
			if a_translation ~ id_variable then
				translation := translation_id
			else
				translation := a_translation
				translation.prune_all_leading ('%N')
				translation.right_adjust
				if translation.has ('%%') then
					translation.unescape (Substitution_mark_unescaper)
				end
			end
			put_table (translation, translation_id)
			if conflict then
				log.put_string_field ("Duplicate id", translation_id)
				log.put_new_line
			end
		end

feature {NONE} -- Build from XML

	last_id: ZSTRING

	translation_text_xpath: STRING
		do
			Result := "item/translation[@lang='%S']/text()"
			Result.replace_substring_all ("%S", language)
		end

	building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["item/@id",				 agent do last_id := node.to_string.twin end],
				[translation_text_xpath, agent do put (node.to_string, last_id) end]
			>>)
		end

	Root_node_name: STRING = "translations"

feature {NONE} -- Constants

	ID_variable: ZSTRING
		once
			Result := "$id"
		end

	Xpath_language_available: ZSTRING
		once
			Result := "boolean (//item[1]/translation[@lang='%S'])"
		end

	Xpath_translations: ZSTRING
		once
			Result :=  "item/translation[@lang='%S']"
		end

	Xpath_parent_id: STRING_32
		once
			Result := "../@id"
		end

	Substitution_mark_unescaper: EL_ESCAPE_TABLE
		local
			table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create table.make_equal (3)
			table ['S'] := '%S'
			create Result.make ('%%', table)
		end

end
