note
	description: "[
		Translation table for text item serializeable as XML
		
		EG.
	
			<item id="Delete current database">
				<translation lang="en">$id</translation>
				<translation lang="de">Löschen aktuellen datenbank</translation>
			</item>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-25 11:04:30 GMT (Monday 25th March 2013)"
	revision: "2"

class
	EL_TEXT_ITEM_TRANSLATIONS_TABLE

inherit
	HASH_TABLE [STRING, STRING]
		rename
			make as make_table
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make as make_builder
		undefine
			copy, is_equal
		end

	EVOLICITY_SERIALIZEABLE
		rename
			make as make_serializeable
		undefine
			copy, is_equal
		end

	EL_MODULE_XML
		undefine
			copy, is_equal
		end

	EL_MODULE_STRING
		undefine
			copy, is_equal
		end

	EL_MODULE_LOG
		undefine
			copy, is_equal
		end

	EL_MODULE_XML
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_comment: like comment)
			--
		do
			comment := a_comment
			make_builder
			make_serializeable
			make_table (7)
			compare_objects

			create id.make_empty
			create last_lang_code.make_empty
		end

feature -- Access

	id: STRING

	comment: STRING

feature -- Element change

	set_id (a_id: like id)
			--
		do
			id := a_id
		end

feature {NONE} -- Evolicity fields

	get_id: STRING
			--
		do
			Result := XML.escaped (id)
		end

	get_comment: STRING
			--
		do
			Result := comment
		end

	get_has_comment: BOOLEAN_REF
			--
		do
			Result := (not comment.is_empty).to_reference
		end

	get_last_lang_code: STRING
			--
		do
			Result := XML.escaped (last_lang_code)
		end

	get_translations: ITERABLE [EVOLICITY_CONTEXT]
			--
		local
			list: ARRAYED_LIST [EVOLICITY_CONTEXT]
		do
			create list.make (2)
			from start until after loop
				list.extend (translation (key_for_iteration, item_for_iteration))
				forth
			end
			Result := list
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["id", agent get_id],
				["last_lang_code", agent get_last_lang_code],
				["translations", agent get_translations],
				["template_name", agent template_name],
				["comment", agent get_comment],
				["has_comment", agent get_has_comment]
			>>)
		end

feature {NONE} -- Build from XML

	set_id_from_node
			--
		do
			id := node.to_string
		end

	set_last_lang_code_from_node
			--
		do
			last_lang_code := node.to_string
		end

	add_translation
			--
		do
			extend (node.to_string, last_lang_code)
		end

	building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["@id", agent set_id_from_node],
				["translation/@lang", agent set_last_lang_code_from_node],
				["translation/text()", agent add_translation]
			>>)
		end

feature {NONE} -- Implementation

	translation (lang_code: STRING; text: STRING): EVOLICITY_CONTEXT_IMPL
			--
		do
			create Result.make
			Result.put_variable (XML.escaped (text), "text")
			Result.put_variable (lang_code, "lang_code")
		end

	last_lang_code: STRING

feature {NONE} -- Constants

	Template: STRING =
		--
	"[
		#if $has_comment then
			
		<!--$comment-->
		<item id="$id">
		#else
		<item id="$id">
		#end
		#foreach $item in $translations loop
			<translation lang="$item.lang_code">$item.text</translation>
		#end
		</item>
	]"

end
