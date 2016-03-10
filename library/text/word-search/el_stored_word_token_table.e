note
	description: "Summary description for {WORD_TOKEN_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:54:08 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_STORED_WORD_TOKEN_TABLE

inherit
	EL_WORD_TOKEN_TABLE
		redefine
			put, flush
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

	EL_MODULE_STRING
		undefine
			is_equal, copy
		end

create
	make_from_file, make_empty

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
		local
			line: EL_ASTRING
		do
			log.enter ("make_from_file")
			create crc
			if a_file_path.exists then
				word_file := open_word_file (a_file_path, Read_file)
				make (word_file.count // 8)
				from until word_file.after loop
					word_file.read_line
					create line.make_from_utf8 (word_file.last_string)

					-- Look for checksum in format: [999]
					if not line.is_empty then
						if String.has_enclosing (line, "[]") then
							String.remove_bookends (line, "[]")
							last_checksum := line.to_natural
						else
							extend (count + 1, line)
							words.extend (line)
							crc.add_string (line)
						end
					end
				end
				word_file.close

				if last_checksum = crc.checksum then
					word_file.open_append
					is_restored := True
				else
					log.put_line ("Checksum does not match")
					word_file.open_write
					crc.reset; wipe_out; words.wipe_out
				end
				last_code := count
			else
				make (100)
				word_file := open_word_file (a_file_path, Write_file)
			end
			log.exit
		end

	make_empty
		do
			make (100)
			create word_file.make_closed
			create crc
		end

feature -- Element change

	append (a_words: ARRAYED_LIST [EL_ASTRING])
		do
			from a_words.start until a_words.after loop
				put (a_words.item)
				a_words.forth
			end
		end

	put (a_word: EL_ASTRING)
			--
		require else
			file_open: is_open
			word_is_normalized: a_word.is_normalized
		do
			Precursor (a_word)
			if not found then
				crc.add_string (a_word)
				word_file.put_string (a_word.to_utf8); word_file.put_new_line
			end
		end

	set_word_file_path (a_file_path: EL_FILE_PATH)
		do
			word_file.rename_file (a_file_path.unicode)
		end

feature -- Status setting

	close
		do
			if last_checksum /= crc.checksum then
				word_file.put_string ("[" + crc.checksum.out + "]")
				word_file.put_new_line
			end
			word_file.close
		end

	close_and_delete
		do
			close
			word_file.delete
		end

	reopen
		do
			word_file.open_append
		end

feature -- Status query

	is_open: BOOLEAN
		do
			Result := not word_file.is_closed
		end

feature -- Basic operations

	flush
		do
			word_file.flush
		end

feature {NONE} -- Implementation

	open_word_file (a_file_path: EL_FILE_PATH; a_mode: INTEGER): like Type_text_file
		do
			inspect a_mode
				when Read_file then
					create Result.make_open_read (a_file_path.unicode)

				when Write_file then
					create Result.make_open_write (a_file_path.unicode)
			else
				create Result.make_with_name (a_file_path.unicode)
			end
		end

	word_file: like Type_text_file

	crc: EL_CYCLIC_REDUNDANCY_CHECK_32

	last_checksum: NATURAL

	data_block_byte_count: INTEGER
		-- bytes read in current data block

feature {NONE} -- Type definitions

	Type_text_file: EL_NOTIFYING_PLAIN_TEXT_FILE
		once
		end

feature -- Constants

	Read_file: INTEGER = 1

	Write_file: INTEGER	= 2

end
