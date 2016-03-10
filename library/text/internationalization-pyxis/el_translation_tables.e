note
	description: "Summary description for {EL_TRANSLATION_TABLES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-25 11:04:53 GMT (Monday 25th March 2013)"
	revision: "2"

class
	EL_TRANSLATION_TABLES

inherit
	ARRAYED_LIST [EL_TEXT_ITEM_TRANSLATIONS_TABLE]
		rename
			make as make_array
		undefine
			default_create
		end

	EL_XML_STORABLE
		undefine
			copy, is_equal
		redefine
			getter_function_table, building_action_table, default_create
		end

	EL_MODULE_LOG
		undefine
			copy, is_equal, default_create
		end

create
	make_from_file, make

feature {NONE} -- Initialization

	default_create
			--
		do
			make_array (100)
			create default_translation.make_empty
			create last_comment.make_empty
		end

feature -- Access

	default_translation: STRING

feature {NONE} -- Evolicity reflection

	get_default_translation: STRING
			--
		do
			Result := default_translation
		end

	get_current: ITERABLE [EL_TEXT_ITEM_TRANSLATIONS_TABLE]
			--
		do
			Result := Current
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["current", agent get_current],
				["default_translation", agent get_default_translation]
			>>)
		end

feature {NONE} -- Build from XML

	set_last_comment
			--
		do
			last_comment := node.to_string
		end

	extend_translation_tables_from_node
			--
		do
			extend (create {EL_TEXT_ITEM_TRANSLATIONS_TABLE}.make (last_comment))
			set_next_context (last)
			create last_comment.make_empty
		end

	set_default_translation_from_node
			--
		do
			default_translation := node.to_string
		end

	building_action_table: like building_actions
			--
		do
			create Result.make (<<
				["item", agent extend_translation_tables_from_node],
				["default-translation/@lang", agent set_default_translation_from_node],
				["comment()", agent set_last_comment]
			>>)
		end

	Root_node_name: STRING = "translation-tables"

feature {NONE} -- Implementation

	last_comment: STRING

feature {NONE} -- Constants

	XML_template: STRING =
		-- Substitution template

	"[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<translation-tables>
			<default-translation lang="$default_translation"/>
		#foreach $item in $current loop
			#evaluate ($item.template_name, $item)
		#end
		</translation-tables>
	]"

end
