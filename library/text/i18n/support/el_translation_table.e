note
	description: "Translation table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-22 9:08:57 GMT (Friday 22nd July 2022)"
	revision: "23"

class
	EL_TRANSLATION_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ZSTRING]
		rename
			make as make_from_map_array,
			put as put_table
		end

	EL_BUILDABLE_FROM_PYXIS
		undefine
			is_equal, copy, default_create
		redefine
			make_default, building_action_table
		end

	EL_MODULE_LIO

create
	make, make_from_root_node, make_from_pyxis_source, make_from_pyxis, make_from_list

feature {NONE} -- Initialization

	make (a_language: STRING)
		do
			language := a_language
			make_default
		end

	make_default
		do
			create last_id.make_empty
			create duplicates.make_empty
			make_equal (60)
			Precursor
		end

	make_from_list (a_language: STRING; items_list: EL_TRANSLATION_ITEMS_LIST)
		do
			make (a_language)
			from items_list.start until items_list.after loop
				put (items_list.item.text, items_list.item.key)
				items_list.forth
			end
		end

	make_from_pyxis (a_language: STRING; pyxis_file_path: FILE_PATH)
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

	make_from_root_node (a_language: STRING; root_node: EL_XML_DOC_CONTEXT)
			-- build from xml
		require
			document_has_translation: document_has_translation (a_language, root_node)
		local
			translations: EL_XPATH_NODE_CONTEXT_LIST
		do
			if is_lio_enabled then
				lio.put_labeled_string ("make_from_root_node",  a_language)
				lio.put_new_line
			end
			make (a_language)
			translations := root_node.context_list (Xpath_translations.substituted_tuple ([language]).to_unicode)
			accommodate (translations.count)
			across translations as translation loop
				put (translation.node.as_full_string, translation.node @ Xpath_parent_id)
			end
		end

feature -- Access

	language: STRING

feature -- Measurement

	word_count: INTEGER
		-- count of all translation words except for variable references
		local
			s: EL_ZSTRING_ROUTINES
		do
			from start until after loop
				Result := Result + s.word_count (item_for_iteration, True)
				forth
			end
		end

feature -- Basic operations

	print_duplicates
		do
			if not duplicates.is_empty then
				across duplicates as id loop
					lio.put_string_field ("id", id.item)
					lio.put_string (" DUPLICATE")
					lio.put_new_line
				end
				lio.put_new_line
			end
		end

feature -- Contract Support

	document_has_translation (a_language: STRING; root_node: EL_XML_DOC_CONTEXT): BOOLEAN
		do
			Result := root_node.is_xpath (Xpath_language_available.substituted_tuple ([a_language]).to_unicode)
		end

feature {NONE} -- Implementation

	put (a_translation, translation_id: ZSTRING)
		local
			translation: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			if a_translation ~ id_variable then
				translation := translation_id
			else
				translation := a_translation
				translation.prune_all_leading ('%N')
				translation.right_adjust
				s.unescape_substitution_marks (translation)
			end
			put_table (translation, translation_id)
			if conflict then
				duplicates.extend (translation_id)
			end
		end

feature {NONE} -- Internal attributes

	duplicates: EL_ZSTRING_LIST

feature {NONE} -- Build from XML

	Root_node_name: STRING = "translations"

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["item/@id",				 agent do last_id := node end],
				[translation_text_xpath, agent do put (node, last_id) end]
			>>)
		end

	last_id: ZSTRING

	translation_text_xpath: STRING
		do
			Result := "item/translation[@lang='%S']/text()"
			Result.replace_substring_all ("%S", language)
		end

feature {NONE} -- Constants

	ID_variable: ZSTRING
		once
			Result := "$id"
		end

	Xpath_language_available: ZSTRING
		once
			Result := "boolean (//item[1]/translation[@lang='%S'])"
		end

	Xpath_parent_id: STRING_32
		once
			Result := "../@id"
		end

	Xpath_translations: ZSTRING
		once
			Result :=  "item/translation[@lang='%S']"
		end

end