note
	description: "Summary description for {EL_LOCALIZATION_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-19 10:30:30 GMT (Tuesday 19th November 2013)"
	revision: "5"

class
	EL_TRANSLATION_TABLE

inherit
	EL_ASTRING_HASH_TABLE [EL_ASTRING]
		rename
			make as make_from_array
		redefine
			extend
		end

	EL_BUILDABLE_FROM_PYXIS
		rename
			make as make_buildable
		undefine
			is_equal, copy, default_create
		redefine
			building_action_table
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_STRING
		undefine
			is_equal, copy, default_create
		end

create
	make_from_root_node, make_from_pyxis_source, make_from_pyxis

feature {NONE} -- Initialization

	make (a_language: STRING)
		do
			language := a_language
			create last_id.make_empty
			make_buildable
			make_equal (11)
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
			has_translation: root_node.is_xpath (Xpath_language_available.substituted (<< a_language >>))
		local
			translation_nodes: EL_XPATH_NODE_CONTEXT_LIST
		do
			log.enter ("make")
			make (a_language)
			translation_nodes := root_node.context_list (Xpath_translations.substituted (<< language >>))
			accommodate (translation_nodes.count)
			across translation_nodes as l_node loop
				extend (l_node.node.string_value, l_node.node.string_at_xpath (Xpath_parent_id))
			end
			log.exit
		end

feature -- Access

	language: STRING

feature {NONE} -- Implementation

	extend (translation, translation_id: EL_ASTRING)
		do
			translation.prune_all_leading ('%N')
			translation.right_adjust
			if translation ~ id_variable then
				Precursor (translation_id, translation_id)
			else
				Precursor (translation, translation_id)
			end
		end

feature {NONE} -- Build from XML

	last_id: EL_ASTRING

	translation_text_xpath: STRING
		do
			Result := "item/translation[@lang='$S']/text()"
			Result.replace_substring_all ("$S", language)
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: bix
		do
			create Result.make (<<
				["item/@id",				 agent do last_id := node.to_string.twin end],
				[translation_text_xpath, agent do extend (node.to_string, last_id) end]
			>>)
		end

	Root_node_name: STRING = "translations"

feature {NONE} -- Constants

	ID_variable: EL_ASTRING
		once
			Result := "$id"
		end

	Xpath_language_available: EL_TEMPLATE_STRING
		once
			Result := "boolean (//item[1]/translation[@lang='$S'])"
		end

	Xpath_translations: EL_TEMPLATE_STRING
		once
			Result :=  "item/translation[@lang='$S']"
		end

	Xpath_parent_id: STRING_32
		once
			Result := "../@id"
		end

end
