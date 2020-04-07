note
	description: "Rbox iradio entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-07 18:19:50 GMT (Tuesday 7th April 2020)"
	revision: "32"

class
	RBOX_IRADIO_ENTRY

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			xml_names as to_kebab_case,
			element_node_type as	Text_element_node,
			New_line as New_line_character
		redefine
			make_default, building_action_table, Except_fields, Field_sets
		end

	EVOLICITY_SERIALIZEABLE
		undefine
			is_equal
		redefine
			make_default, getter_function_table, Template
		end

	RHYTHMBOX_CONSTANTS
		rename
			Media_type as Media_types
		end

	EL_XML_ESCAPING_CONSTANTS undefine is_equal end

	RBOX_DATABASE_FIELDS undefine is_equal end

	HASHABLE undefine is_equal end

	EL_MODULE_XML

	EL_MODULE_LOG

	SHARED_DATABASE

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_SERIALIZEABLE}
			media_type := Media_types.octet_stream
		end

	make
		do
			make_default
			music_dir := Database.music_dir
		end

feature -- Rhythmbox XML fields

	genre: ZSTRING

	media_type: STRING

	title: ZSTRING

	hidden: NATURAL_8

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

	relative_location: EL_FILE_PATH
		do
			Result := location.relative_path (music_dir)
		end

	url_encoded_location_uri: ZSTRING
		do
			Result := database.encoded_location_uri (location_uri)
		end

	music_dir: EL_DIR_PATH

feature -- Element change

	set_genre (a_genre: like genre)
			--
		do
			Genre_set.put (a_genre)
			genre := Genre_set.found_item
		end

	set_location (a_location: like location)
			--
		do
			location := a_location
			location.enable_out_abbreviation
		end

	set_media_type (a_media_type: like media_type)
		do
			Media_type_set.put (a_media_type)
			media_type := Media_type_set.found_item
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make_equal (field_table.count)
			across Build_types as type loop
				Result.merge (building_actions_for_type (type.item, Text_element_node))
			end
			Result ["location/text()"] := agent do set_location (database.decoded_location (node.to_string_8)) end
		end

	Build_types: ARRAY [TYPE [ANY]]
		once
			Result := << {DOUBLE}, {NATURAL_8}, {INTEGER}, {ZSTRING}, {STRING} >>
		end

feature {NONE} -- Evolicity fields

	get_string_8_fields: EL_REFERENCE_FIELD_VALUE_TABLE [STRING]
		do
			create Result.make (2)
			fill_field_value_table (Result)
		end

	get_non_empty_string_fields: EL_ESCAPED_ZSTRING_FIELD_VALUE_TABLE
		do
			create Result.make (11, Xml_128_plus_escaper)
			Result.set_condition (agent (str: ZSTRING): BOOLEAN do Result := not str.is_empty end)
			fill_field_value_table (Result)
		end

	get_non_zero_integer_fields: EL_INTEGER_FIELD_VALUE_TABLE
		do
			create Result.make (11)
			Result.set_condition (agent (v: INTEGER): BOOLEAN do Result := v /= v.zero end)
			fill_field_value_table (Result)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				-- title is included for reference by template loaded from DJ_EVENT_HTML_PAGE
				["title", 							agent: ZSTRING do Result := Xml.escaped (title) end],
				["genre_main", 					agent: ZSTRING do Result := Xml.escaped (genre_main) end],
				["location_uri", 					agent: STRING do Result := Xml.escaped (url_encoded_location_uri) end],
				["media_type",						agent: STRING do Result := media_type end],
				["non_zero_integer_fields", 	agent get_non_zero_integer_fields],
				["non_empty_string_fields",	agent get_non_empty_string_fields]
			>>)
		end

	Template: STRING
			--
		once
			Result := "[
			<entry type="iradio">
				<media-type>$media_type</media-type>
			#across $non_empty_string_fields as $field loop
				<$field.key>$field.item</$field.key>
			#end
				<location>$location_uri</location>
				<date>0</date>
			</entry>
			]"
		end

feature {NONE} -- Constants

	Field_sets: EL_HASH_TABLE [EL_HASH_SET [STRING_GENERAL], STRING]
		once
			create Result.make (<<
				["genre", Genre_set],
				["media_type", Media_type_set],
				["title", Title_set]
			>>)
		end

	Genre_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (50)
		end

	Media_type_set: EL_HASH_SET [STRING]
		once
			create Result.make_from_array (Media_type_list.to_array)
		end

	Except_fields: STRING
			-- Object attributes that are not stored in Rhythmbox database
		once
			Result := Precursor + ", encoding_bitmap"
		end

	Protocol: ZSTRING
		once
			Result := "http"
		end

	Title_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (100)
		end

end
