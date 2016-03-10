note
	description: "Summary description for {EL_ENCRYPTABLE_PLAIN_TEXT_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-06 10:39:35 GMT (Wednesday 6th May 2015)"
	revision: "5"

class
	EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE

inherit
	EL_NOTIFYING_PLAIN_TEXT_FILE
		export
			{NONE} all
			{ANY} put_string, put_new_line, after, read_line, last_string,
					extendible, file_readable, readable, is_closed,
					close, count
		redefine
			make_with_name, put_string, read_line, open_append, open_write, open_read
		end

	EL_ENCRYPTABLE

create
	make_with_name, make_open_read, make_open_write

feature -- Initialization

	make_with_name (fn: READABLE_STRING_GENERAL)
			-- Create file object with `fn' as file name.
		do
			Precursor {EL_NOTIFYING_PLAIN_TEXT_FILE} (fn)
			make_default_encryptable
		end

feature -- Access

	line_start: INTEGER
		-- First line to start decryption from

	line_index: INTEGER

feature -- Element change

	put_string (s: STRING)
		do
			Precursor (encrypter.base64_encrypted (s))
		end

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
				last_string := encrypter.decrypted_base64 (last_string)
				if is_prepared_for_append then
					call (encrypter.base64_encrypted (last_string))
				end
			end
		end

feature {NONE} -- Implementation

	call (object: ANY)
		do
		end

end
