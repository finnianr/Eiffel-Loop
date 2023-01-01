note
	description: "Exports object conforming to [$source EL_REFLECTIVELY_SETTABLE] as XML document"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 12:54:34 GMT (Sunday 1st January 2023)"
	revision: "1"

class
	EL_XML_OBJECT_EXPORTER [G -> EL_REFLECTIVELY_SETTABLE create make_default end]

inherit
	ANY

	EL_REFLECTION_HANDLER

	EL_MODULE_REUSEABLE; EL_MODULE_XML; EL_MODULE_TUPLE

	XML_ZSTRING_CONSTANTS

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
			across Reuseable.string as reuse loop
				value := reuse.item
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
							output.put_indent (tab_count + 1); output.put_string_8 (field.item.name)
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

feature {NONE} -- Implementation

	put_child_elements (
		output: EL_OUTPUT_MEDIUM; field_list: LIST [EL_REFLECTED_FIELD]; value: ZSTRING; tab_count: INTEGER
	)
		local
			needs_escaping: BOOLEAN
		do
			across field_list as field loop
				if attached {EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]} field.item as context_field then
					if attached {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT} context_field.value (object) as context then
						if attached object as previous_object then
							object := context
							put_element (output, field.item.name, tab_count + 1)
							object := previous_object
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

	put_value (output: EL_OUTPUT_MEDIUM; value: ZSTRING; escape: BOOLEAN)
		do
			if escape then
				output.put_string_general (Xml_escaper.escaped (value, False))
			else
				output.put_string_general (value)
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

	Item_name: STRING = "item"
		-- list item name

	New_line: CHARACTER = '%N'

	Null: CHARACTER = '%/0/'

	XML_string: TUPLE [attribute_start, element_close: STRING]
		once
			create Result
			Tuple.fill_adjusted (Result,  " = %",/>%N", False)
		end
end