note
	description: "Translation table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-24 8:23:06 GMT (Wednesday 24th July 2024)"
	revision: "34"

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

	EL_SHARED_KEY_LANGUAGE

create
	make, make_from_xdoc, make_from_pyxis_source, make_from_pyxis, make_from_list

feature {NONE} -- Initialization

	make (a_language: STRING)
		do
			language := a_language
			make_default
		end

	make_default
		do
			create last_id.make_empty
			create duplicate_list.make_empty
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

	make_from_xdoc (a_language: STRING; xdoc: EL_XML_DOC_CONTEXT)
			-- build from xml
		require
			document_has_translation: document_has_translation (a_language, xdoc)
		do
			if is_lio_enabled then
				lio.put_labeled_string ("make_from_xdoc",  a_language)
				lio.put_new_line
			end
			make (a_language)
			if attached new_translation_map_list (a_language, xdoc, False) as list then
				accommodate (list.count)
				from list.start until list.after loop
					put (list.item_value, list.item_key)
					list.forth
				end
			end
		end

feature -- Access

	language: STRING

feature -- Measurement

	duplicate_count: INTEGER
		do
			Result := duplicate_list.count
		end

	word_count: INTEGER
		-- count of all translation words except for variable references
		local
			z: EL_ZSTRING_ROUTINES
		do
			from start until after loop
				Result := Result + z.word_count (item_for_iteration, True)
				forth
			end
		end

feature -- Basic operations

	print_duplicates
		do
			across duplicate_list as id loop
				lio.put_string_field ("id", id.item)
				lio.put_string (" DUPLICATE")
				lio.put_new_line
			end
			lio.put_new_line
		end

feature -- Status query

	has_duplicates: BOOLEAN
		do
			Result := duplicate_list.count > 0
		end

feature -- Contract Support

	document_has_translation (a_language: STRING; xdoc: EL_XML_DOC_CONTEXT): BOOLEAN
		do
			if attached new_translation_map_list (a_language, xdoc, True) as list
				and then list.count = 1
			then
				Result := list.first_value /= Empty_string
			end
		end

feature {NONE} -- Implementation

	new_translation_map_list (
		a_language: STRING; xdoc: EL_XML_DOC_CONTEXT; first_only: BOOLEAN

	): EL_ARRAYED_MAP_LIST [ZSTRING, ZSTRING]
		require
			document_has_translation: document_has_translation (a_language, xdoc)
		local
			item_context_list: EL_XPATH_NODE_CONTEXT_LIST; item_id: ZSTRING
			translation_xpath: STRING_32; done: BOOLEAN
		do
			translation_xpath := Xpath_translation_at_lang #$ [a_language]
			item_context_list := xdoc.context_list (Xpath_item)
			create Result.make (item_context_list.count)
			across item_context_list as list until done loop
				item_id := list.node [Attribute_id]
				if a_language ~ Key_language implies not item_id.has_enclosing ('{', '}') then
					Result.extend (item_id, item_id)

				elseif attached list.node.find_node (translation_xpath) as translation then
					Result.extend (item_id, translation.as_full_string)
				else
					Result.extend (item_id, Empty_string)
				end
				if first_only then
					done := True
				end
			end
		end

	put (a_translation, translation_id: ZSTRING)
		local
			translation: ZSTRING; z: EL_ZSTRING_ROUTINES
		do
			if a_translation ~ id_variable then
				translation := translation_id
			else
				translation := a_translation
				translation.prune_all_leading ('%N')
				translation.right_adjust
				z.unescape_substitution_marks (translation)
			end
			put_table (translation, translation_id)
			if conflict then
				duplicate_list.extend (translation_id)
			end
		end

feature {NONE} -- Internal attributes

	duplicate_list: EL_ZSTRING_LIST

	last_id_is_text: BOOLEAN

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["item/@id", agent set_last_id_from_node],
				[translation_text_xpath, agent extend_table_from_node]
			>>)
		end

	extend_table_from_node
		do
			if language ~ Key_language implies not last_id_is_text then
				put (node, last_id)
			end
		end

	last_id: ZSTRING

	set_last_id_from_node
		do
			last_id := node.to_string
			if language ~ Key_language then
				last_id_is_text := not last_id.has_enclosing ('{', '}')
				if last_id_is_text then
					put (last_id, last_id)
				end
			end
		end

	translation_text_xpath: STRING
		local
			template: ZSTRING
		do
			template := "item/translation[@lang='%S']/text()"
			Result := template #$ [language]
		end

feature {NONE} -- Constants

	Attribute_id: STRING = "id"

	ID_variable: ZSTRING
		once
			Result := "$id"
		end

	Root_node_name: STRING = "translations"

	Xpath_item: STRING_8 = "item"

	Xpath_translation_at_lang: ZSTRING
		once
			Result :=  "translation[@lang='%S']"
		end

end