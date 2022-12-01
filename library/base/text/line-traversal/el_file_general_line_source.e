note
	description: "[
		Interface for object that interates over the lines of an file object conforming to [$source PLAIN_TEXT_FILE].
		The line items conform to [$source STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 10:25:40 GMT (Thursday 1st December 2022)"
	revision: "2"

deferred class
	EL_FILE_GENERAL_LINE_SOURCE [S -> STRING_GENERAL create make end]

inherit
	EL_LINEAR [S]

	ITERABLE [S]

	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		redefine
			make_default
		end

	EL_MODULE_ENCODING
		rename
			Encoding as Mod_encoding
		end

feature {NONE} -- Initialization

	make (a_file: like Default_file)
		do
			make_default
			set_file (a_file)
			if a_file.exists then
				check_encoding
			end
			is_file_external := True
		end

	make_default
			--
		do
			Precursor
			create item.make (0)
			file := default_file
		end

feature -- Access

	bom_count: INTEGER
		-- byte order mark count

	count: INTEGER

	index: INTEGER

	item: S

feature -- Conversion

	as_list: like new_list
			--
		local
			is_shared: BOOLEAN
		do
			is_shared := is_shared_item
			is_shared_item := False
			Result := new_list (file.count // 10)
			from start until after loop
				Result.extend (item)
				forth
			end
			is_shared_item := is_shared
		end

feature -- Access

	joined: S
		local
			is_shared: BOOLEAN
		do
			is_shared := is_shared_item
			is_shared_item := True
			create Result.make (file.count)
			from start until after loop
				if index > 1 then
					Result.append_code ({EL_ASCII}.Newline)
				end
				Result.append (item)
				forth
			end
			is_shared_item := is_shared
		end

	new_cursor: EL_LINE_SOURCE_ITERATION_CURSOR [S]
			--
		do
			create Result.make (Current)
			Result.start
		end

feature -- Status query

	after: BOOLEAN
			-- Is there no valid position to the right of current one?
		do
			Result := index = count + 1
		end

	is_empty: BOOLEAN
			-- Is there no element?
		do
			Result := attached file implies file.is_empty
		end

	is_file_external: BOOLEAN
		-- True if file is managed externally to object

	is_open: BOOLEAN
			--
		do
			Result := file.is_open_read
		end

	is_shared_item: BOOLEAN
		-- True if only one instance of `item' created

feature -- Output

	print_first (log: EL_LOGGABLE; n: INTEGER)
		-- print first `n' lines to `log' output with leading tabs expanded to 3 spaces
		local
			line: ZSTRING; tab_count: INTEGER; s: EL_ZSTRING_ROUTINES
		do
			across Current as ln until ln.cursor_index > n loop
				create line.make_from_general (ln.item)
				tab_count := line.leading_occurrences ('%T')
				if tab_count > 0 then
					line.replace_substring (s.n_character_string (' ', tab_count * 3), 1, tab_count)
				end
				log.put_line (line)
			end
			if not after then
				log.put_line ("..")
			end
		end

feature -- Cursor movement

	forth
		-- Move to next position
		require else
			file_is_open: is_open
		local
			found_item: BOOLEAN
		do
			if attached file as f then
				if not f.end_of_file then
					read_line (f)
					if f.end_of_file then
						found_item := f.last_string.count > 0
					else
						found_item := True
					end
				end
				if found_item then
					update_item
					count := count + 1
				end
				index := index + 1
				if after and not is_file_external then
					f.close
				end
			end
		ensure then
			closed_if_eof: after and not is_file_external implies file.is_closed
		end

	start
		-- Move to first position if any.
		do
			if file = default_file then
				index := 1
				count := 0
			else
				open_at_start
				count := 0
				if file.off then
					index := 1
					item.keep_head (0)
				else
					index := 0
					forth
				end
			end
		end

feature -- Status setting

	close
			--
		do
			if file.is_open_read then
				file.close
			end
		end

	disable_shared_item
		-- when enabled the same instance of `item' is always returned
		do
			is_shared_item := False
		end

	enable_shared_item
		-- when enabled the same instance of `item' is always returned
		do
			is_shared_item := True
		end

	open_at_start
		do
			if not file.is_open_read then
				file.open_read
			end
			file.go (bom_count)
		end

feature -- Basic operations

	delete_file
			--
		do
			if file.is_open_read then
				file.close
			end
			file.delete
		end

feature {NONE} -- Unused

	finish
			-- Move to last position.
		do
		end

feature {EL_LINE_SOURCE_ITERATION_CURSOR} -- Implementation

	check_encoding
		do
			if attached {EL_STRING_IO_MEDIUM} file as medium then
				set_encoding (medium.encoding)

			elseif attached Mod_encoding.file_info (file) as info then
				bom_count := info.bom_count
				encoding_detected := info.detected
				if encoding_detected then
					set_encoding (info.encoding)
				end
			end
		end

	new_list (n: INTEGER): EL_ARRAYED_LIST [S]
		do
			create Result.make (n)
		end

	read_line (f: like Default_file)
		do
			f.read_line
		end

	set_file (a_file: like Default_file)
		do
			file := a_file
		end

	update_item
		deferred
		end

feature {NONE} -- Internal attributes

	encoding_detected: BOOLEAN

	file: like default_file

feature {NONE} -- Constants

	Default_file: PLAIN_TEXT_FILE
		once
			create Result.make_with_name ("default.txt")
		end

end