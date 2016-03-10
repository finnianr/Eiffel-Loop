note
	description: "Summary description for {EL_TRANSLATION_TABLES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:01 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_TRANSLATION_TABLE_GROUPS

inherit
	ARRAYED_LIST [EL_TRANSLATION_GROUP]
		rename
			make as make_array,
			item as group
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make as make_serializer,
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
	make_from_file

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
			--
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			make_with_output_file (a_file_path)

			create root_node.make_from_file (a_file_path)

			make_array (root_node.integer_at_xpath ("count (//translation-tables/group)"))
			default_translation := root_node.string_at_xpath ("/translation-tables/default-translation/@lang")

			root_node.context_list ("/translation-tables/group").do_all (
				agent (group_node: EL_XPATH_NODE_CONTEXT)
					do
						extend (create {like group}.make_from_xpath_node (group_node))
					end
			)
		end

feature -- Access

	default_translation: STRING

feature {NONE} -- Evolicity reflection

	get_default_translation: STRING
			--
		do
			Result := default_translation
		end

	get_current: ITERABLE [like group]
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

feature {NONE} -- Constants

	XML_template: STRING =
		-- Substitution template

	"[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<translation-tables>
			<default-translation lang="$default_translation"/>
		#foreach $group in $current loop
			#evaluate ($group.template_name, $group)
		#end
		</translation-tables>
	]"

end
