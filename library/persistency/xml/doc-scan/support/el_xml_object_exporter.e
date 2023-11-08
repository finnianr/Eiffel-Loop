note
	description: "Exports object conforming to [$source EL_REFLECTIVELY_SETTABLE] as XML document"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 10:31:45 GMT (Wednesday 8th November 2023)"
	revision: "5"

class
	EL_XML_OBJECT_EXPORTER [G -> EL_REFLECTIVELY_SETTABLE create make_default end]

inherit
	ANY

	EVOLICITY_CLIENT

	EL_DOCUMENT_CLIENT

	EL_REFLECTION_HANDLER

	EL_MODULE_TUPLE

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make, make_default

feature {NONE} -- Initialization

	make (a_object: G)
		do
			object := a_object
		end

	make_default
		do
			create {G} object.make_default
		end

feature -- Basic operations

	put_header (output: EL_OUTPUT_MEDIUM)
		local
			XML: XML_ROUTINES
		do
			output.put_string_8 (XML.header (1.0, output.encoding_name))
			output.put_new_line
		end

	put_element (output: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER)
		-- recursively output elements to file as XML
		local
			has_child_element: BOOLEAN; field_list: LIST [EL_REFLECTED_FIELD]
			attribute_count: INTEGER; l_name: STRING; value: ZSTRING
		do
			if attached {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT} object as builder_context then
				field_list := builder_context.importable_list
			else
				field_list := object.meta_data.field_list
			end
			across String_scope as scope loop
				value := scope.item
				output.put_indent (tab_count); output.put_character_8 ('<')
				output.put_string_8 (name)
				across field_list as field loop
					l_name := field.item.name
					if attached {EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]} field.item
						or else attached {EL_REFLECTED_COLLECTION [ANY]} field.item
						or else attached {EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]} field.item
					then
						has_child_element := True
					else
						value.wipe_out
						field.item.write (object, value)
						if not value.is_empty then
							if attribute_count = 0 then
								output.put_new_line
							end
							output.put_indent (tab_count + 1); output.put_string_8 (l_name)
							output.put_string_8 (XML_string.attribute_start)
							put_value (output, value, attached {EL_REFLECTED_STRING [STRING_GENERAL]} field.item)
							output.put_character_8 ('"')
							output.put_new_line
							attribute_count := attribute_count + 1
						end
					end
				end
				if has_child_element then
					output.put_character_8 ('>')
					output.put_new_line
					put_child_elements (output, field_list, value, tab_count)
					put_tag_close (output, name, tab_count, New_line)
				else
					output.put_indent (tab_count)
					output.put_string_8 (XML_string.element_close)
				end
			end
		end

	put_evolicity_element (
		output: EL_OUTPUT_MEDIUM; name: STRING; building_actions: EL_PROCEDURE_TABLE [STRING]
		context: EVOLICITY_EIFFEL_CONTEXT; tab_count: INTEGER
	)
		-- output a non-reflective `EL_EIF_OBJ_BUILDER_CONTEXT' context which also conforms to
		-- `EVOLICITY_EIFFEL_CONTEXT'
		local
			function: FUNCTION [ANY]; field_name: STRING; element_table: like Element_value_table
			attribute_count: INTEGER
		do
			element_table := Element_value_table
			element_table.wipe_out

			output.put_indent (tab_count); output.put_character_8 ('<')
			output.put_string_8 (name)
			across context.getter_functions as table loop
				function := table.item
				if function.open_count = 0 then
					function.set_target (context); function.apply
					if attached {READABLE_STRING_GENERAL} function.last_result as value then
						field_name := table.key
						if is_xml_element (field_name, building_actions) then
							element_table.extend (value, field_name)
						else
							output.put_new_line
							output.put_indent (tab_count + 1)
							output.put_string_8 (field_name)
							output.put_string_8 (XML_string.attribute_start)
							put_value (output, value, True)
							output.put_character_8 ('"')
							attribute_count := attribute_count + 1
						end
					end
				end
			end
			if attribute_count > 0 then
				output.put_new_line
				output.put_indent (tab_count)
			end
			if element_table.count > 0 then
				output.put_character_8 ('>')
				output.put_new_line
				across element_table as table loop
					field_name := table.key
					put_tag_open (output, field_name, tab_count + 1, Null)
					put_value (output, table.item, True)
					put_tag_close (output, field_name, 0, Null)
					output.put_new_line
				end
				put_tag_close (output, name, tab_count, New_line)
			else
				output.put_string_8 (XML_string.element_close)
			end
		end

feature {NONE} -- Implementation

	is_xml_element (name: STRING; building_actions: EL_PROCEDURE_TABLE [STRING]): BOOLEAN
		local
			xpath: STRING
		do
			across building_actions as table until Result loop
				xpath := table.key
				if name.count + Text_node.count = xpath.count then
					Result := xpath.starts_with (name) and then xpath.ends_with (Text_node)
				end
			end
		end

	put_child_elements (
		output: EL_OUTPUT_MEDIUM; field_list: LIST [EL_REFLECTED_FIELD]; value: ZSTRING; tab_count: INTEGER
	)
		local
			needs_escaping: BOOLEAN; name: STRING; building_actions: EL_PROCEDURE_TABLE [STRING]
		do
			across field_list as field loop
				name := field.item.name
				if attached {EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]} field.item as context_field then
					if attached {EL_EIF_OBJ_BUILDER_CONTEXT} context_field.value (object) as context then
						building_actions := context.building_actions

						if attached {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT} context as reflective_context then
							if attached object as previous_object then
								object := reflective_context
								put_element (output, name, tab_count + 1)
								object := previous_object
							end
						elseif attached {EVOLICITY_EIFFEL_CONTEXT} context as evolicity then
							put_evolicity_element (output, name, building_actions, evolicity, tab_count + 1)
						end
					end

				elseif attached {EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]} field.item as collection_field then
					if attached {COLLECTION [EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]}
						collection_field.collection (object) as collection
					then
						put_tag_open (output, collection_field.name, tab_count + 1, New_line)
						if attached collection.linear_representation as list
							and then attached object as previous_object
						then
							from list.start until list.after loop
								object := list.item
								put_element (output, Item_name, tab_count + 2)
								list.forth
							end
							object := previous_object
						end
						put_tag_close (output, collection_field.name, tab_count + 1, New_line)
					end
				elseif attached {EL_REFLECTED_COLLECTION [ANY]} field.item as collection_field then
					needs_escaping := collection_field.has_character_data
					put_tag_open (output, collection_field.name, tab_count + 1, New_line)
					across collection_field.to_string_list (object) as general loop
						put_tag_open (output, Item_name, tab_count + 2, Null)
						value.wipe_out
						value.append_string_general (general.item)
						put_value (output, value, needs_escaping)
						put_tag_close (output, Item_name, 0, New_line)
					end
					put_tag_close (output, collection_field.name, tab_count + 1, New_line)

				end
			end
		end

	put_value (output: EL_OUTPUT_MEDIUM; general_value: READABLE_STRING_GENERAL; escape: BOOLEAN)
		do
			if escape then
				if attached {ZSTRING} general_value as value then
					output.put_string_general (Xml_escaper.escaped (value, False))

				elseif attached {STRING} general_value as value then
					output.put_string_general (Xml_escaper_8.escaped (value, False))
				else
					put_value (output, Buffer.copied_general (general_value), escape)
				end
			else
				output.put_string_general (general_value)
			end
		end

	put_tag_open (output: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER; character: CHARACTER)
		do
			put_tag (output, name, tab_count, False, character)
		end

	put_tag_close (output: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER; character: CHARACTER)
		do
			put_tag (output, name, tab_count, True, character)
		end

	put_tag (output: EL_OUTPUT_MEDIUM; name: STRING; tab_count: INTEGER; closed: BOOLEAN; character: CHARACTER)
		do
			output.put_indent (tab_count)
			output.put_character_8 ('<')
			if closed then
				output.put_character_8 ('/')
			end
			output.put_string_8 (name)
			output.put_character_8 ('>')
			if character = New_line then
				output.put_new_line
			end
		end

feature {NONE} -- Internal attributes

	object: EL_REFLECTIVE

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

	Element_value_table: HASH_TABLE [READABLE_STRING_GENERAL, STRING]
		once
			create Result.make (3)
		end

	Item_name: STRING = "item"
		-- list item name

	New_line: CHARACTER = '%N'

	Null: CHARACTER = '%/0/'

	Text_node: STRING = "/text()"
		-- list item name

	Xml_escaper: XML_ESCAPER [ZSTRING]
		once
			create Result.make
		end

	Xml_escaper_8: XML_ESCAPER [STRING_8]
		once
			create Result.make
		end

	XML_string: TUPLE [attribute_start, element_close: STRING]
		once
			create Result
			Tuple.fill_adjusted (Result,  " = %",/>%N", False)
		end
end