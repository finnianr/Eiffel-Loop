note
	description: "Evolicity serializeable as xml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-14 17:21:15 GMT (Thursday 14th February 2019)"
	revision: "5"

deferred class
	EVOLICITY_SERIALIZEABLE_AS_XML

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			as_text as to_xml,
			as_utf_8_text as to_utf_8_xml,
			serialize_to_file as save_as_xml
		export
			{ANY} Template
		redefine
			is_bom_enabled, new_getter_functions, stored_successfully
		end

	EL_SERIALIZEABLE_AS_XML

feature -- Access

	Root_element_name: STRING
			--
		require
			xml_template_ends_with_tag: Template.item (Template.count) = '>'
		local
			pos_last_left_bracket: INTEGER
		do
			pos_last_left_bracket := Template.last_index_of ('<', Template.count)
			Result := Template.substring (pos_last_left_bracket + 2, Template.count - 1).to_string_8
		end

feature -- Status query

	is_bom_enabled: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	stored_successfully (a_file: like new_file): BOOLEAN
		require else
			xml_template_ends_with_tag: Template.item (Template.count) = '>'
		local
			closing_tag: STRING
		do
			closing_tag := "</" + Root_element_name + ">"
			a_file.go (a_file.count - closing_tag.count)
			a_file.read_line
			Result := closing_tag ~ a_file.last_string
		end

	new_getter_functions: like getter_functions
			--
		do
			Result := Precursor
			Result [Variable_to_xml] :=  agent to_xml
		end

feature {NONE} -- Constants

	Variable_to_xml: ZSTRING
		once
			Result := "to_xml"
		end

end
