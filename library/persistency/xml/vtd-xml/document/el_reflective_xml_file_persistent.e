note
	description: "[
		Reflective implementation of {EL_XML_FILE_PERSISTENT} with name of root element
		generated from class name.
	]"
	notes: "[
		This is an experimental class and works for classes with attribute fields that consist of
		basic expanded types and strings.
	]"
	descendants: "[
			EL_REFLECTIVE_XML_FILE_PERSISTENT*
				${MICROSOFT_COMPILER_OPTIONS}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 14:51:22 GMT (Saturday 22nd March 2025)"
	revision: "1"

deferred class
	EL_REFLECTIVE_XML_FILE_PERSISTENT

inherit
	EL_XML_FILE_PERSISTENT
		redefine
			root_element_name, root_node_name
		end

	EL_MODULE_NAMING

	EVC_REFLECTIVE_XML_CONTEXT

	EL_CHARACTER_8_CONSTANTS

feature {NONE} -- Initialization

	make_from_xdoc (xdoc: EL_XML_DOC_CONTEXT)
		do
			if attached xdoc.find_node (char ('/') + root_element_name) as root_node then
				across current_reflective.field_list as list loop
					if attached list.item as field
						and then attached root_node.find_node (field.export_name) as node
					then
						field.set_from_readable (current_reflective, node)
					end
				end
			end
		end

feature -- Access

	root_element_name, root_node_name: STRING
		do
			Result := Naming.class_as_kebab_lower (Current, 0, 0)
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["root_name",	  agent root_element_name],
				["element_list", agent xml_element_list]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING
		once
			Result := "[
				<?xml version="1.0" encoding="$encoding_name"?>
				<$root_name>
				#foreach $element in $element_list loop
					$element
				#end
				</$root_name>
			]"
		end

end