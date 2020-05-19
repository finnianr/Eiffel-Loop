note
	description: "Rhythmbox radio station entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-19 8:57:27 GMT (Tuesday 19th May 2020)"
	revision: "38"

class
	RBOX_IRADIO_ENTRY

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as to_kebab_case,
			element_node_type as	Text_element_node,
			New_line as New_line_character
		redefine
			make, building_action_table, Except_fields, Field_sets
		end

	EVOLICITY_SERIALIZEABLE
		rename
			make_default as make
		undefine
			is_equal
		redefine
			make, getter_function_table, Template
		end

	HASHABLE undefine is_equal end

	EL_XML_ESCAPING_CONSTANTS

	EL_MODULE_XML

	EL_MODULE_LOG

	SHARED_DATABASE

	RBOX_SHARED_DATABASE_FIELD_ENUM

	RBOX_IRADIO_FIELDS

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_SERIALIZEABLE}
			media_type := Media_types.octet_stream
			string_field_table := Default_string_table
			music_dir := Database.music_dir
		end

feature -- Access

	genre_main: ZSTRING
			--
		local
			bracket_pos: INTEGER
		do
			bracket_pos := genre.index_of ('(', 1)
			if bracket_pos > 0 then
				Result := genre.substring (1, bracket_pos - 2)
			else
				Result := genre
			end
		end

	hash_code: INTEGER
		do
			Result := location.hash_code
		end

	location: EL_FILE_PATH

	location_uri: EL_FILE_URI_PATH
		do
			create Result.make_protocol (Protocol, location)
		end

	music_dir: EL_DIR_PATH

	relative_location: EL_FILE_PATH
		do
			Result := location.relative_path (music_dir)
		end

	url_encoded_location_uri: ZSTRING
		do
			Result := database.encoded_location_uri (location_uri)
		end

feature -- Element change

	set_location (a_location: like location)
			--
		do
			location := a_location
			location.enable_out_abbreviation
		end

	set_string_field (field_code: NATURAL_16; value: ZSTRING)
		-- set extra field not in attributes
		require
			valid_string_field: valid_string_field (field_code)
		do
			if string_field_table = Default_string_table then
				create string_field_table.make_equal (3)
			end
			string_field_table [field_code] := value
		end

feature -- Contract Support

	valid_string_field (field_code: NATURAL_16): BOOLEAN
		-- valid extra field
		do
			if not field_table.has (Db_field.name (field_code)) then
				Result := DB_field.is_string_type (field_code)
			end
		end

	all_non_string_fields_are_class_attributes: BOOLEAN
		do
			Result := across DB_field.sorted as field all
				not DB_field.is_string_type (field.item) implies field_table.has (DB_field.field_name (field.item))
			end
		end

feature {NONE} -- Build from XML

	Build_types: ARRAY [TYPE [ANY]]
		once
			Result := << {DOUBLE}, {NATURAL_8}, {INTEGER}, {ZSTRING}, {STRING} >>
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		require else
			all_non_string_fields_are_class_attributes: all_non_string_fields_are_class_attributes
		local
			l_xpath: STRING
		do
			create Result.make_equal (field_table.count)
			across Build_types as l_type loop
				Result.merge (building_actions_for_type (l_type.item, Text_element_node))
			end
			Result ["location/text()"] := agent do set_location (database.decoded_location (node.to_string_8)) end
			across DB_field.sorted as enum loop
				if DB_field.is_string_type (enum.item) then
					l_xpath := DB_field.name_exported (enum.item, False) + "/text()"
					Result.put (agent set_string_field_from_node (enum.item), l_xpath)
				end
			end
		end

	set_string_field_from_node (field_code: NATURAL_16)
		do
			set_string_field (field_code, node)
		end

feature {NONE} -- Evolicity fields

	Template: STRING = "[
		<entry type="$type">
		#foreach $element in $element_list loop
			$element
		#end
		</entry>
	]"

	get_element_list: like Element_list
		local
			element: EL_XML_TEXT_ELEMENT; always_saved: BOOLEAN
		do
			Result := Element_list
			Result.wipe_out
			across DB_field.sorted as enum loop
				always_saved := DB_field.always_saved_set.has (enum.item)
				element := DB_field.xml_element (enum.item)
				element.text.wipe_out

				if enum.item = DB_field.location then
						element.text.append (url_encoded_location_uri)

				elseif field_table.has_key (DB_field.field_name (enum.item)) then
					if attached {EL_REFLECTED_NUMERIC_FIELD [NUMERIC]} field_table.found_item as numeric then
						if always_saved or else not numeric.is_zero (Current) then
							numeric.write (Current, element.text)
						end
					else
						field_table.found_item.write (Current, element.text)
					end

				elseif string_field_table.has_key (enum.item) then
					element.text.append (string_field_table.found_item)

				end
				if always_saved or else not element.text.is_empty then
					Result.extend (element.to_latin_1 (True))
				end
			end
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				-- title is included for reference by template loaded from DJ_EVENT_HTML_PAGE
				["title", 				agent: ZSTRING do Result := Xml.escaped (title) end],
				["genre_main", 		agent: ZSTRING do Result := Xml.escaped (genre_main) end],
				["location_uri", 		agent: STRING do Result := Xml.escaped (url_encoded_location_uri) end],
				["media_type",			agent: STRING do Result := media_type end],
				["type",					agent: STRING do Result := type end],
				["element_list",		agent get_element_list]
			>>)
		end

feature {NONE} -- Initialization

	string_field_table: like Default_string_table
		-- extra string fields

feature {NONE} -- Constants

	Default_string_table: HASH_TABLE [ZSTRING, NATURAL_16]
		once
			create Result.make (0)
		end

	Default_xml_elememt: EL_XML_EMPTY_ELEMENT
		once
			create Result.make ("")
		end

	Element_list: EL_STRING_8_LIST
		once
			create Result.make (0)
		end

	Except_fields: STRING
			-- Object attributes that are not stored in Rhythmbox database
		once
			Result := Precursor + ", encoding"
		end

	Field_sets: EL_HASH_TABLE [EL_HASH_SET [STRING_GENERAL], STRING]
		once
			create Result.make (<<
				["genre", Genre_set],
				["media_type", Media_type_set],
				["title", Title_set]
			>>)
		end

	Protocol: ZSTRING
		once
			Result := "http"
		end

	Type: STRING
		once
			Result := "iradio"
		end

end
