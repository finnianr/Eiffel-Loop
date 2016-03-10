note
	description: "Summary description for {RBOX_IRADIO_ENTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-11 13:18:13 GMT (Monday 11th November 2013)"
	revision: "4"

class
	RBOX_IRADIO_ENTRY

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make_default
		end

	EVOLICITY_SERIALIZEABLE
		rename
			make_empty as make
		redefine
			make_default, getter_function_table, Template
		end

	EL_MODULE_XML

	EL_MODULE_LOG

	RHYTHMBOX_CONSTANTS

	HASHABLE

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			create title.make_empty
			create genre.make_empty
			create location
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_SERIALIZEABLE}
		end

feature -- Access

	location: EL_FILE_PATH

	title: ASTRING

	genre: ASTRING

	genre_main: ASTRING
			--
		do
			Result := genre.split (' ').first
		end

	hash_code: INTEGER
		do
			Result := location.hash_code
		end

	location_uri: ASTRING
		do
			Result := Url.uri (Protocol, location)
		end

	url_encoded_location_uri: ASTRING
		do
			Result := Url.uri (Protocol, location)
			Result := Url.escape_custom (location_uri.to_utf8, Unescaped_location_characters, False)
		end

feature -- Element change

	set_location_from_uri (a_uri: ASTRING)
		do
			location := Url.remove_protocol_prefix (a_uri)
			location.enable_out_abbreviation
		ensure
			reversible: a_uri ~ location_uri
		end

	set_location (a_location: like location)
			--
		do
			location := a_location
		end

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["location/text()", 	agent do set_location_from_uri (Url.unicode_decoded_path (node.to_string)) end],
				["title/text()", 		agent do title := node.to_string end],
				["genre/text()", 		agent do genre := node.to_string end]
			>>)
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["title", 				agent: ASTRING do Result := Xml.escaped (title) end],
				["genre", 				agent: ASTRING do Result := Xml.escaped (genre) end],
				["genre_main", 		agent: ASTRING do Result := Xml.escaped (genre_main) end],
				["location_uri", 		agent: STRING do Result := Xml.escaped (url_encoded_location_uri) end]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING
			--
		once
			Result := "[
			<entry type="iradio">
				<title>$title</title>
				<genre>$genre</genre>
				<artist></artist>
				<album></album>
				<location>$location_uri</location>
				<date>0</date>
				<mimetype>application/octet-stream</mimetype>
				<mb-trackid></mb-trackid>
				<mb-artistid></mb-artistid>
				<mb-albumid></mb-albumid>
				<mb-albumartistid></mb-albumartistid>
				<mb-artistsortname></mb-artistsortname>
			</entry>
			]"
		end

	Protocol: STRING
		once
			Result := "http"
		end

end
