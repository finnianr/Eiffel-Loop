note
	description: "Email"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:36 GMT (Tuesday 18th March 2025)"
	revision: "19"

deferred class
	EL_EMAIL

inherit
	EVC_SERIALIZEABLE_AS_ZSTRING
		rename
			output_path as email_path
		redefine
			make_default, serialize
		end

	EL_FILE_OPEN_ROUTINES

	EL_STRING_8_CONSTANTS; EL_CHARACTER_8_CONSTANTS

feature {NONE} -- Initialization

	make_default
		local
			boundary: INTEGER
		do
			Precursor
			create date_time.make_now_utc
			boundary := date_time.time.compact_time + ($Current).to_integer_32
			multipart_boundary := hyphen * 12 + boundary.to_hex_string
		end

feature -- Basic operations

	serialize
		do
			File_system.make_directory (email_path.parent)
			if attached open (email_path, Write) as file_out then
				file_out.set_encoding_from_other (Current)
				across as_text.lines as line loop
					file_out.put_string (line.item)
					file_out.put_encoded_character_8 ('%R')
					file_out.put_new_line
				end
				file_out.close
			end
		end

feature -- Access

	date_time: DATE_TIME

	from_address: ZSTRING
		deferred
		end

	to_address: ZSTRING
		deferred
		end

feature {NONE} -- Implementation

	date_string: STRING
		local
			parts: EL_ZSTRING_LIST
		do
			create parts.make_word_split (date_time.formatted_out (Date_format))
			Result := parts.joined_propercase_words.to_string_8
		end

	multipart_boundary: STRING

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["date", 			agent date_string],
				["to_address", 	agent: ZSTRING do Result := to_address end ],
				["from_address", 	agent: ZSTRING do Result := from_address end],
				["boundary", 		agent: STRING do Result := multipart_boundary end]
			>>)
		end

feature {NONE} -- Constants

	Date_format: STRING = "ddd, dd mmm yyyy hh:[0]mm:[0]ss +0000"

end