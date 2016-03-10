note
	description: "Summary description for {EL_ENCRYPTABLE_PLAIN_TEXT_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-22 19:28:08 GMT (Friday 22nd March 2013)"
	revision: "3"

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
			create encrypter
		end

feature -- Access

	line_start: INTEGER
		-- First line to start decryption from

	line_index: INTEGER

feature -- Element change

	put_string (s: STRING)
		do
			Precursor {EL_NOTIFYING_PLAIN_TEXT_FILE} (encrypter.base64_encrypted (s))
		end

	set_line_start (a_line_start: like line_start)
		do
			line_start := a_line_start
		end

feature -- Status report

	is_encrypter_synchronized: BOOLEAN
		-- True if encryption chain is synchronized for appending to file

feature -- Status setting

	set_encrypter_synchronization
		do
			is_encrypter_synchronized := True
		end

	open_append
		require else
			encrypter_synchronized: is_encrypter_synchronized
		do
			precursor {EL_NOTIFYING_PLAIN_TEXT_FILE}
		end

	open_write
		do
			encrypter.reset
			precursor {EL_NOTIFYING_PLAIN_TEXT_FILE}
		end

	open_read
		do
			line_index := 0
			Precursor {EL_NOTIFYING_PLAIN_TEXT_FILE}
		end

feature -- Input

	read_line
		do
			Precursor {EL_NOTIFYING_PLAIN_TEXT_FILE}
			line_index := line_index + 1
			if line_index >= line_start and then not last_string.is_empty then
				last_string := encrypter.decrypted_base64 (last_string)
				if is_encrypter_synchronized then
					synchronize_encryption_chain
				end
			end
		end

feature {NONE} -- Initialization

	synchronize_encryption_chain
			-- Synchronize encryption chain for appending to file
		local
			base_64: STRING
		do
			base_64 := encrypter.base64_encrypted (last_string)
		end

end
