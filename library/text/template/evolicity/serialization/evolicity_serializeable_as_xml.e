note
	description: "Evolicity serializeable as xml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-09 13:04:05 GMT (Saturday 9th October 2021)"
	revision: "8"

deferred class
	EVOLICITY_SERIALIZEABLE_AS_XML

inherit
	EVOLICITY_SERIALIZEABLE_AS_STRING_8
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
			Result [Variable_to_xml] :=  agent to_xml
		end

	stored_successfully (a_file: like new_file): BOOLEAN
		require else
			xml_template_ends_with_tag: Template.item (Template.count) = '>'
		local
			closing_tag: STRING
		do
			closing_tag := "</" + root_element_name + ">"
			a_file.go (a_file.count - closing_tag.count)
			a_file.read_line
			Result := closing_tag ~ a_file.last_string
		end

feature {NONE} -- Constants

	Variable_to_xml: ZSTRING
		once
			Result := "to_xml"
		end

end