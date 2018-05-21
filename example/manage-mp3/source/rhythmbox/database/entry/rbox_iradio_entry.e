note
	description: "Rbox iradio entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "16"

class
	RBOX_IRADIO_ENTRY

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		undefine
			is_equal
		redefine
			make, on_context_exit
		end

	EVOLICITY_SERIALIZEABLE
		rename
			make_default as make
		undefine
			is_equal
		redefine
			make, getter_function_table, Template
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_string_or_expanded_field,
			export_name as to_kebab_case,
			import_name as import_default
		redefine
			make, Except_fields
		end

	EL_SETTABLE_FROM_XML_NODE
		undefine
			is_equal
		redefine
			set_field_from_node
		end

	EL_MODULE_XML
		undefine
			is_equal
		end

	EL_MODULE_LOG
		undefine
			is_equal
		end

	RHYTHMBOX_CONSTANTS
		undefine
			is_equal
		end

	EL_XML_ESCAPING_CONSTANTS
		undefine
			is_equal
		end

	HASHABLE
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor {EL_REFLECTIVELY_SETTABLE}
			create location
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_SERIALIZEABLE}
		end

feature -- Rhythmbox XML fields

	genre: ZSTRING

	media_type: ZSTRING

	title: ZSTRING

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

	url_encoded_location_uri: ZSTRING
		do
			Result := Url.encoded_uri_custom (location_uri , Unescaped_location_characters, False)
		end

feature -- Element change

	set_location (a_location: like location)
			--
		do
			location := a_location
		end

	set_location_from_uri (a_uri: ZSTRING)
		do
			location := Url.remove_protocol_prefix (a_uri)
			location.enable_out_abbreviation
		ensure
			reversible: a_uri ~ location_uri
		end

	set_media_type (a_media_type: like media_type)
		do
			media_type := a_media_type
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			Result := building_actions_for_type ({ZSTRING}, Text_element_node) +
				["location/text()", agent do set_location_from_uri (Url.decoded_path (node.to_string_8)) end]
		end

	on_context_exit
		do
			Media_types.start
			Media_types.search (media_type)
			if not Media_types.exhausted then
				media_type := Media_types.item
			end
		end

	set_field_from_node (field: EL_REFLECTED_FIELD)
		do
			if field.type_id = String_z_type
				and then attached {ZSTRING} field.value (Current) as value
				and then value ~ Unknown_string
			then
				field.set (Current, Unknown_string)
			else
				field.set_from_readable (Current, node)
			end
		end

feature {NONE} -- Evolicity fields

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
				["non_zero_integer_fields", 	agent get_non_zero_integer_fields],
				["non_empty_string_fields",	agent get_non_empty_string_fields]
			>>)
		end

feature {NONE} -- Constants

	Except_fields: STRING
			-- Object attributes that are not stored in Rhythmbox database
		once
			Result := Precursor + ", internal_encoding, xpath"
		end

	Protocol: ZSTRING
		once
			Result := "http"
		end

	Template: STRING
			--
		once
			Result := "[
			<entry type="iradio">
			#across $non_empty_string_fields as $field loop
				<$field.key>$field.item</$field.key>
			#end
				<location>$location_uri</location>
				<date>0</date>
			</entry>
			]"
		end

	Unknown_string: ZSTRING
		once
			Result := "Unknown"
		end

end
