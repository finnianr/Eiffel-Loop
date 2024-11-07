note
	description: "HTML ${EL_DOC_TYPE} with ability to parse HTML document for `charset' encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 14:27:50 GMT (Tuesday 5th November 2024)"
	revision: "19"

class
	EL_HTML_DOC_TYPE

inherit
	EL_DOC_TYPE
		rename
			make as make_doc_type
		end

	EL_MODULE_HTML

	EL_ENCODING_TYPE
		export
			{NONE} all
		end

	EL_SHARED_STRING_8_BUFFER_POOL

create
	make, make_from_file

feature {NONE} -- Initialization

	make_from_file (a_file_path: FILE_PATH)
		do
			make (Utf_8)
			set_from_file (a_file_path)
		end

	make (a_encoding: NATURAL)
		require
			valid_encoding: Encoding_.is_valid (a_encoding)
		do
			make_doc_type (Text_type.name (Text_type.HTML), a_encoding)
		end

feature -- Element change

	set_from_file (a_file_path: FILE_PATH)
		local
			file: PLAIN_TEXT_FILE; found: BOOLEAN
		do
			create file.make_open_read (a_file_path)
			if file.exists then
				if attached String_8_pool.borrowed_item as borrowed then
					if attached borrowed.empty as buffer then
						from until found or file.end_of_file loop
							file.read_line
							buffer.append (file.last_string)
							buffer.append_character ('%N')
							if file.last_string.has_substring ("charset=") then
								found := True
							end
						end
						if found then
							encoding.set_from_name (HTML.encoding_name (buffer))
							specification := new_specification
						end
					end
					borrowed.return
				end
			end
			file.close
		end
end