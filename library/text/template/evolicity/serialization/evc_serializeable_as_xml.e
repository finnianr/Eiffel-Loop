note
	description: "Evolicity serializeable as xml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 14:02:33 GMT (Saturday 22nd March 2025)"
	revision: "12"

deferred class
	EVC_SERIALIZEABLE_AS_XML

inherit
	EVC_SERIALIZEABLE_AS_STRING_8
		rename
			as_text as to_xml,
			serialize_to_file as save_as_xml
		export
			{ANY} Template
		redefine
			is_bom_enabled, new_getter_functions, stored_successfully
		end

	EL_SERIALIZEABLE_AS_XML

	EL_MODULE_XML

feature -- Access

	root_element_name, root_node_name: STRING
			--
		do
			Result := XML.root_element_name (template)
		end

feature -- Status query

	is_bom_enabled: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	new_getter_functions: like getter_functions
			--
		do
			Result := Precursor
			Result [Var.to_xml] :=  agent to_xml
		end

	stored_successfully (a_file: like new_file): BOOLEAN
		require else
			xml_template_ends_with_tag: Template [Template.count] = '>'
		do
			if attached XML.closed_tag (root_element_name) as name then
				a_file.read_final_line (name.count + 1) -- plus one is necessary it seems
				Result := name.same_string_general (a_file.last_string)
			end
		end

end