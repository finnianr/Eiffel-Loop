note
	description: "Summary description for {EL_BINARY_EDITIONS_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 12:53:40 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_CHAIN_EDITIONS_FILE [G -> EL_MEMORY_READ_WRITEABLE]

inherit
	EL_NOTIFYING_RAW_FILE
		rename
			make as make_file,
			count as file_count
		end

create
	make

feature -- Initialization

	make (a_file_path: EL_FILE_PATH; a_storable_chain: like item_chain)
		local
			i: INTEGER
		do
			item_chain := a_storable_chain
			reader_writer := item_chain.reader_writer
			create crc
			make_with_name (a_file_path.unicode)
			if exists then
				open_read
				if not is_empty then
					read_header
					from i := 1 until i > count or end_of_file loop
						read_edition_code
						if not end_of_file then
							skip_edition (last_edition_code)
						end
						if not end_of_file then
							inspect last_edition_code when Edition_code_extend, Edition_code_replace then
								new_item_count := new_item_count + 1
							else
							end
						end
						i := i + 1
					end
					actual_count := i - 1
				end
				close
			else
				open_write; put_header; close
			end
		end

feature -- Access

	count: INTEGER
		-- reported edition count

	actual_count: INTEGER
		-- count of editions found

	new_item_count: INTEGER
		-- count of editions that call new_item

	crc: EL_CYCLIC_REDUNDANCY_CHECK_32

	kilo_byte_count: REAL
		do
			Result := (file_count / 1024).truncated_to_real
		end

	last_edition_code: CHARACTER

	item_chain: EL_STORABLE_CHAIN [G]

feature -- Status report

	has_checksum_mismatch: BOOLEAN
		-- Has the file become corrupted somewhere

	has_editions: BOOLEAN
		do
			Result := count > 0
		end

feature -- Status change

	close_and_delete
			--
		do
			close; delete
		end

feature {EL_STORABLE_CHAIN_EDITIONS} -- Basic operations

	apply
		local
			i: INTEGER
		do
			open_read
			read_header
			from i := 1 until i > actual_count or has_checksum_mismatch or end_of_file loop
				read_edition
				i := i + 1
			end
			close
		end

	put_edition (edition_code: CHARACTER; a_item: G)
		do
			put_character (edition_code)
			crc.add_character (edition_code)
			inspect edition_code when Edition_code_remove, Edition_code_replace then
				put_integer (item_chain.index)
				crc.add_integer (item_chain.index)
			else
			end
			inspect edition_code when Edition_code_replace, Edition_code_extend then
				reader_writer.write (a_item, Current)
				crc.add_data (reader_writer.data)
			else
			end
			put_natural (crc.checksum)
			count := count + 1
			-- Write count at start
			start; put_header; finish
			flush
		end

feature {NONE} -- Implementation

	put_header
		do
			put_integer (count)
		end

	read_header
		do
			read_integer_32
			count := last_integer_32
		end

	skip_header
		do
			move ({PLATFORM}.integer_32_bytes)
		end

	read_edition
		local
			edition_index: INTEGER
			l_item: G
		do
			read_edition_code
			crc.add_character (last_edition_code)
			inspect last_edition_code when Edition_code_remove, Edition_code_replace then
				read_integer
				edition_index := last_integer
				crc.add_integer (edition_index)
			else
			end
			inspect last_edition_code when Edition_code_replace, Edition_code_extend then
				l_item := item_chain.new_item
				reader_writer.read (l_item, Current)
				crc.add_data (reader_writer.data)
			else
			end
			read_natural
			checksum := last_natural
			if checksum = crc.checksum then
				inspect last_edition_code
					when Edition_code_remove then
						item_chain.go_i_th (edition_index); item_chain.remove

					when Edition_code_replace then
						item_chain.go_i_th (edition_index); item_chain.replace (l_item)

					when Edition_code_extend then
						item_chain.extend (l_item)
				else
				end
			else
				has_checksum_mismatch := True
			end
		end

	read_edition_code
		do
			read_character
			last_edition_code := last_character
		end

	skip_edition (edition_code: CHARACTER)
		local
			item_size: INTEGER
		do
			inspect edition_code when Edition_code_remove, Edition_code_replace then
				read_integer -- list index
			else
			end
			if not end_of_file then
				inspect edition_code when Edition_code_replace, Edition_code_extend then
					read_integer
					item_size := last_integer
				else
					if not end_of_file then
						move (item_size)
					end
				end
			end
			if not end_of_file then
				read_natural -- checksum
			end
		end

	reader_writer: EL_FILE_READER_WRITER

	checksum: NATURAL

feature -- Constants

	Edition_code_replace: CHARACTER = '1'

	Edition_code_extend: CHARACTER = '2'

	Edition_code_remove: CHARACTER = '3'

end
