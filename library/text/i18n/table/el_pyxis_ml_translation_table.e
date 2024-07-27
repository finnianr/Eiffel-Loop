note
	description: "[
		${EL_MULTI_LANGUAGE_TRANSLATION_TABLE} that is initialized by a localization configuration
		file in Pyxis format.

			pyxis-doc:
				version = 1.0; encoding = "ISO-8859-1"

			# class TEST_PHRASES_TEXT
			# Testing ISO-8859-1 encoding in EL_MERGED_PYXIS_LINE_LIST

			translations:
				item:
					id = "Enter a passphrase"
					# first has no check
					translation:
						lang = de
						'Geben sie ein passphrase für "$NAME" tagebuch'
					translation:
						lang = en
						'Enter a passphrase for "$NAME" journal'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-27 14:36:07 GMT (Saturday 27th July 2024)"
	revision: "1"

class
	EL_PYXIS_ML_TRANSLATION_TABLE

inherit
	EL_MULTI_LANGUAGE_TRANSLATION_TABLE

	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_string as make_from_source
		undefine
			is_equal, copy, default_create
		redefine
			building_action_table, make_default
		end

	EL_STRING_8_CONSTANTS

create
	make_from_source, make_from_file

feature {NONE} -- Initialization

	make_default
		do
			make_equal (17)
			Precursor
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["item/@id",										agent set_last_id_from_node],
				["item/translation/@lang",						agent do last_language := node.to_string_8 end],
				[translation_text_xpath (Empty_string_8), agent do put (last_language, node, last_id) end]
			>>)
			across Quantifier_names as name loop
				Result [translation_text_xpath ("/" + name.item)] := agent extend_table_from_quantifier_node
			end
		end

	extend_table_from_quantifier_node
		-- find quantifier from name
		-- translations/item/translation/singular/text()
		local
			start_index, end_index: INTEGER
		do
			end_index := xpath.count - 7 -- ("/text()").count
			start_index := xpath.last_index_of ('/', end_index) + 1
			if attached quantifier_suffix (xpath.substring (start_index, end_index)) as suffix then
				put (last_language, node.to_string, last_id + suffix)
			end
		end

	set_last_id_from_node
		do
			last_id := node.to_string
			if is_translatable (last_id) then
				last_language := Key_language
				put (last_language, last_id, last_id)
			end
		end

	translation_text_xpath (path_step: STRING): STRING
		do
			Result := Xpath_item_template #$ [path_step]
		end

feature {NONE} -- Internal attributes

	last_id: ZSTRING

	last_language: STRING

feature {NONE} -- Constants

	Root_node_name: STRING = "translations"

	Xpath_item_template: ZSTRING
		once
			Result := "item/translation%S/text()"
		end

end