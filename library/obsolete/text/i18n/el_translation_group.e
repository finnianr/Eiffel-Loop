note
	description: "Summary description for {EL_TRANSLATION_GROUP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_TRANSLATION_GROUP

inherit
	ARRAYED_LIST [EL_TEXT_ITEM_TRANSLATIONS_TABLE]
		rename
			make as make_array
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make as make_serializeable,
			serialize as store,
			safe_serialize as safe_store
		undefine
			copy, is_equal
		end

	EL_MODULE_LOG
		undefine
			copy, is_equal
		end

create
	make_from_xpath_node

feature {NONE} -- Initialization

	make_from_xpath_node (group_node: EL_XPATH_NODE_CONTEXT)
			--
		do
			make_serializeable
			name := group_node.attributes ["name"]
			make_array (group_node.integer_at_xpath ("count (item)"))

			group_node.context_list ("item").do_all (
				agent (node_item: EL_XPATH_NODE_CONTEXT)
					do
--						extend (create {EL_TEXT_ITEM_TRANSLATIONS_TABLE}.make_from_xpath_node (node_item))
					end
			)
		end

feature -- Access

	name: STRING

feature {NONE} -- Evolicity reflection

	get_name: STRING
			--
		do
			Result := name
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
				["name", agent get_name]
			>>)
		end

feature {NONE} -- Implementation

	last_comment: STRING

feature {NONE} -- Constants

	XML_template: STRING =
		-- Substitution template

	"[
		<group name="$name">
		#foreach $item in $current loop
			#evaluate ($item.template_name, $item)
		#end
		</group>
	]"

end
