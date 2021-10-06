note
	description: "Evolicity serializeable as xml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-06 10:23:13 GMT (Wednesday 6th October 2021)"
	revision: "7"

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

feature -- Access

	root_element_name, root_node_name: STRING
			--
		local
			left_bracket_index, i: INTEGER
		do
			left_bracket_index := template.last_index_of ('<', template.count)
			if left_bracket_index > 0 then
				create Result.make (template.count - left_bracket_index - 3)
				i := left_bracket_index + 1
				if template [i] = '/' then
					i := i + 1
				end
				from until i > template.count or else not is_identifier (template [i]) loop
					Result.append_character (template [i].to_character_8)
					i := i + 1
				end
			else
				create Result.make_empty
			end
		end

feature -- Status query

	is_bom_enabled: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	is_identifier (uc: CHARACTER_32): BOOLEAN
		do
			inspect uc
				when 'a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-' then
					Result := True
			else
			end
		end

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