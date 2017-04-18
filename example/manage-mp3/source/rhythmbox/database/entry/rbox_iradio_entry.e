note
	description: "Summary description for {RBOX_IRADIO_ENTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-24 18:25:50 GMT (Tuesday 24th January 2017)"
	revision: "2"

class
	RBOX_IRADIO_ENTRY

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make, set_string_field, on_context_exit
		end

	EVOLICITY_SERIALIZEABLE
		rename
			make_default as make
		redefine
			make, getter_function_table, Template
		end

	EL_MODULE_XML

	EL_MODULE_LOG

	RHYTHMBOX_CONSTANTS

	EL_XML_ESCAPING_CONSTANTS

	HASHABLE

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			title := Empty_string; genre := Empty_string; media_type := Empty_string
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

	location_uri: ZSTRING
		do
			Result := Url.uri (Protocol, location)
		end

	url_encoded_location_uri: ZSTRING
		do
			Result := Url.uri (Protocol, location)
			Result := Url.escape_custom (location_uri.to_utf_8, Unescaped_location_characters, False)
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

	building_action_table: like Type_building_actions
			--
		do
			Result := building_actions_for_type ({ZSTRING}, Fields_not_stored, Hyphen)
			Result ["location/text()"] := agent do set_location_from_uri (Url.decoded_path (node.to_string_8)) end
		end

	on_context_exit
		do
			Media_types.start
			Media_types.search (media_type)
			if not Media_types.exhausted then
				media_type := Media_types.item
			end
		end

	set_string_field (i: INTEGER)
		local
			value: ZSTRING
		do
			value := node.to_string
			if value ~ Unknown_string then
				value := Unknown_string
			end
			current_object.set_reference_field (i, value)
		end

feature {NONE} -- Evolicity fields

	get_non_empty_string_fields: EL_STRING_FIELD_VALUE_TABLE [ZSTRING]
		do
			create Result.make (11)
			Result.set_escaper (Xml_128_plus_escaper)
			Result.set_condition (agent (str: ZSTRING): BOOLEAN do Result := not str.is_empty end)
			fill_field_table (Result, Fields_not_stored, '-')
		end

	get_non_zero_integer_fields: EL_INTEGER_FIELD_VALUE_TABLE
		do
			create Result.make (11)
			Result.set_condition (agent (v: INTEGER): BOOLEAN do Result := v /= v.zero end)
			fill_field_table (Result, Fields_not_stored, '-')
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

	Fields_not_stored: ARRAY [STRING]
			-- Object attributes that are not stored in Rhythmbox database
		once
			Result := << "album_artists_prefix", "encoding" >>
		end

	Protocol: STRING
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

	Hyphen: CHARACTER
			-- Eiffel field names adapted for Rbox XML
		once
			Result := '-'
		end

	Unknown_string: ZSTRING
		once
			Result := "Unknown"
		end
end
