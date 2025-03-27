note
	description: "Encrypted text file using AES cipher blocks chains"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-27 7:48:15 GMT (Thursday 27th March 2025)"
	revision: "18"

class
	EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE

inherit
	EL_NOTIFYING_PLAIN_TEXT_FILE
		export
			{NONE} all
			{ANY} put_string, put_string_general, put_string_32, put_string_8, put_encoded_string_8, put_new_line,
					read_line, last_string, close, count,
					after, extendible, encoded_as_utf, file_readable, readable, is_closed, end_of_file
		redefine
			make_default, put_string, put_string_8, put_encoded_string_8, put_string_general, read_line,
			open_append, open_write, open_read
		end

	EL_ENCRYPTABLE
		redefine
			make_default
		end

create
	make_with_name, make_open_read, make_open_write

feature -- Initialization

	make_default
		do
			Precursor {EL_ENCRYPTABLE}
			Precursor {EL_NOTIFYING_PLAIN_TEXT_FILE}
		end

feature -- Access

	line_start: INTEGER
		-- First line to start decryption from

	line_index: INTEGER

feature -- Write string

	put_string_general (str: READABLE_STRING_GENERAL)
		do
			if attached String_8_pool.borrowed_item as borrowed then
				put_encoded_string_8 (borrowed.copied_general_as_utf_8 (str))
				borrowed.return
			end
		end

	put_string (str: ZSTRING)
		do
			if attached String_8_pool.borrowed_item as borrowed
				and then attached borrowed.empty as str_8
			then
				str.append_to_utf_8 (str_8)
				put_encoded_string_8 (str_8)
				borrowed.return
			end
		end

	put_string_8 (str: READABLE_STRING_8)
		do
			if attached String_8_pool.borrowed_item as borrowed then
				put_encoded_string_8 (borrowed.copied_as_utf_8 (str))
				borrowed.return
			end
		end

	put_encoded_string_8 (s: STRING)
		do
			Precursor (encrypter.base_64_encrypted (s))
		end

feature -- Element change

	set_line_start (a_line_start: like line_start)
		do
			line_start := a_line_start
		end

feature -- Status report

	is_prepared_for_append: BOOLEAN
		-- True if encryption chain state is prepared during reads for later appending

feature -- Status setting

	prepare_for_append
		do
			is_prepared_for_append := True
		end

	open_append
		require else
			prepared_for_append: is_prepared_for_append
		do
			Precursor
		end

	open_write
		do
			encrypter.reset
			precursor
		end

	open_read
		do
			encrypter.reset
			line_index := 0
			Precursor
		end

feature -- Input

	read_line
		do
			Precursor
			line_index := line_index + 1
			if line_index >= line_start and then not last_string.is_empty then
				last_string := encrypter.decrypted_base_64 (last_string)
				if is_prepared_for_append then
					call (encrypter.base_64_encrypted (last_string))
				end
			end
		end

	call (object: ANY)
		do
		end

end