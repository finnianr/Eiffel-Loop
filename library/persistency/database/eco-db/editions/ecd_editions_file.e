note
	description: "Eco-DB chain editions file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 8:19:39 GMT (Thursday 11th July 2024)"
	revision: "20"

class
	ECD_EDITIONS_FILE [G -> EL_STORABLE create make_default end]

inherit
	RAW_FILE
		rename
			make as make_file,
			count as file_count
		export
			{ECD_RECOVERABLE_CHAIN} set_path
		redefine
			delete
		end

	EL_SHARED_PROGRESS_LISTENER

create
	make

feature -- Initialization

	make (a_storable_chain: like item_chain)
		do
			item_chain := a_storable_chain
			reader_writer := item_chain.reader_writer
			create crc.make
			make_with_name (Default_name)
		end

feature -- Access

	actual_count: INTEGER
		-- count of editions found

	delta_count: INTEGER
		-- difference that applied editions have made to `item_chain.count'

	count: INTEGER
		-- reported edition count

	crc: EL_CYCLIC_REDUNDANCY_CHECK_32

	extended_byte_count: INTEGER
		-- total data bytes that extend list

	item_chain: ECD_STORABLE_CHAIN [G]

	kilo_byte_count: REAL
		do
			Result := (file_count / 1024).truncated_to_real
		end

	last_edition_code: CHARACTER

	read_count: INTEGER
		-- count of editions successfully read

feature -- Status report

	has_checksum_mismatch: BOOLEAN
		-- Has the file become corrupted somewhere

	is_bigger: BOOLEAN
		-- `True' if file is bigger since object was created
		do
			Result := file_count > attributes.file_count
		end

	is_read_complete: BOOLEAN
		do
			Result := read_count = count
		end

	is_reset: BOOLEAN
		-- `True' if edition count is zero
		do
			Result := count = 0
		end

feature -- Removal

	close_and_delete
			--
		do
			if not is_closed then
				close
			end
			if exists then
				delete
			end
		end

	delete
		do
			Precursor
			count := 0; actual_count := 0; extended_byte_count := 0
			crc.reset
		end

feature {ECD_RECOVERABLE_CHAIN} -- Element change

	set_attributes (a_file_path: FILE_PATH)
		local
			i, l_position: INTEGER
		do
			make_with_name (a_file_path)
			if exists then
				attributes := [file_count, date]
				open_read
				if not is_empty then
					read_header
					from i := 1 until i > count or end_of_file loop
						read_edition_code
						l_position := position
						if not end_of_file then
							skip_edition (last_edition_code)
							if last_edition_code = Code_extend then
								extended_byte_count := extended_byte_count + position - l_position
							end
						end
						i := i + 1
					end
					actual_count := i - 1
				end
				close
			else
				attributes := [0, 0]
				open_write; put_header; close
			end
		end

feature {ECD_RECOVERABLE_CHAIN} -- Basic operations

	apply
		local
			i: INTEGER
		do
			if exists and then not is_empty then
				open_read
				read_header
				from i := 1 until i > actual_count or has_checksum_mismatch or end_of_file loop
					read_edition
					i := i + 1
				end
				close
				read_count := i - 1
			end
			reopen
		end

	put_edition (edition_code: CHARACTER; a_item: G)
		do
			put_character (edition_code)
			crc.add_character_8 (edition_code)
			inspect edition_code when Code_delete, Code_remove, Code_replace then
				put_integer (item_chain.index)
				crc.add_integer (item_chain.index)
			else
			end
			inspect edition_code when Code_extend, Code_replace then
				reader_writer.set_for_writing
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

	restore_date
		do
			if attributes.date_stamp > 0 then
				set_date (attributes.date_stamp)
			end
		end

feature -- Status change

	reopen
		do
			if exists then
				open_read_write
				finish
			else
				open_write; put_header; close
				reopen
			end
		end

feature {NONE} -- Implementation

	put_header
		do
			put_integer (count)
		end

	read_edition
		local
			edition_index: INTEGER
			l_item: G
		do
			read_edition_code
			crc.add_character_8 (last_edition_code)
			inspect last_edition_code when Code_delete, Code_remove, Code_replace then
				read_integer
				edition_index := last_integer
				crc.add_integer (edition_index)
			else
			end
			inspect last_edition_code when Code_extend, Code_replace then
				reader_writer.set_for_reading
				l_item := reader_writer.read_item (Current)
				crc.add_data (reader_writer.data)
			else
			end
			read_natural
			checksum := last_natural
			if checksum = crc.checksum then
				inspect last_edition_code
					when Code_delete then
						item_chain.go_i_th (edition_index); item_chain.delete

					when Code_extend then
						item_chain.extend (l_item)
						delta_count := delta_count + 1

					when Code_remove then
						item_chain.go_i_th (edition_index); item_chain.remove
						delta_count := delta_count - 1

					when Code_replace then
						item_chain.go_i_th (edition_index); item_chain.replace (l_item)

				else
				end
			else
				has_checksum_mismatch := True
			end
			progress_listener.notify_tick
		end

	read_edition_code
		do
			read_character
			last_edition_code := last_character
		end

	read_header
		-- read expected count
		do
			read_integer_32
			count := last_integer_32
		end

	skip_edition (edition_code: CHARACTER)
		local
			item_size: INTEGER
		do
			inspect edition_code when Code_remove, Code_replace then
				read_integer -- list index
			else
			end
			if not end_of_file then
				inspect edition_code when Code_replace, Code_extend then
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

	skip_header
		do
			move ({PLATFORM}.integer_32_bytes)
		end

feature {NONE} -- Internal attributes

	checksum: NATURAL

	reader_writer: ECD_READER_WRITER [G]

	attributes: TUPLE [file_count, date_stamp: INTEGER]

feature -- Constants

	Code_delete: CHARACTER = '4'

	Code_extend: CHARACTER = '2'

	Code_remove: CHARACTER = '3'

	Code_replace: CHARACTER = '1'

feature {NONE} -- Constants

	Minimum_editions_to_integrate: REAL
			-- Minimum file size in kb of editions to integrate with main XML body.
		once
			Result := 50 -- Kb
		end

	Default_name: STRING = "default"

end