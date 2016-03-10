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
	date: "2013-03-25 10:43:20 GMT (Monday 25th March 2013)"
	revision: "3"

class
	EL_TEXT_ITEM_TRANSLATIONS_TABLE

inherit
	HASH_TABLE [STRING, STRING]
		rename
			make as make_table
		end

	EVOLICITY_SERIALIZEABLE
		rename
			make as make_serializeable
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
	make_from_xpath_node

feature {NONE} -- Initialization

	make_from_xpath_node (item_node: EL_XPATH_NODE_CONTEXT)
			--
		local
			lang_code: STRING
		do
			make_serializeable
			make_table (item_node.integer_at_xpath ("count(translation)"))
			compare_objects
			id := item_node.attributes ["id"]

			across item_node.context_list ("translation") as node loop
				lang_code := node.item.attributes ["lang"]
				if node.item.normalized_string_value ~ "$id" then
					extend (id, lang_code)
				else
					extend (node.item.normalized_string_value, lang_code)
				end
			end
		end

feature -- Access

	id: STRING

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
				["translations", agent get_translations]
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

feature {NONE} -- Constants

	Template: STRING =
		--
	"[
		<item id="$id">
		#across $translations as $translation loop
			#if $translation.item.text = $id then
			<translation lang="$translation.item.lang_code">$$id</translation>
			#else
			<translation lang="$translation.item.lang_code">$item.text</translation>
			#end
		#end
		</item>
	]"

end
