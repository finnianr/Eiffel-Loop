note
	description: "[
		Interface for object that interates over the lines of an file object conforming to
		`PLAIN_TEXT_FILE'. The lines are assumed to be UTF-8 encoded by default and are converted to
		`ZSTRING' items.
	]"
	descendants: "[
			EL_FILE_LINE_SOURCE*
				[$source EL_ZSTRING_IO_MEDIUM_LINE_SOURCE]
				[$source EL_PLAIN_TEXT_LINE_SOURCE]
					[$source EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE]
					[$source EL_STRING_8_IO_MEDIUM_LINE_SOURCE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-08 10:11:28 GMT (Friday 8th May 2020)"
	revision: "9"

deferred class
	EL_FILE_LINE_SOURCE

inherit
	EL_LINEAR [ZSTRING]

	ITERABLE [ZSTRING]

	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make (a_file: like file)
		do
			make_default
			file := a_file
			if attached {EL_PLAIN_TEXT_FILE} a_file as plain then
				set_encoding (plain.encoding)
			end
			is_file_external := True
		end

	make_default
			--
		do
			Precursor
			create item.make_empty
			file := default_file
		end

feature -- Access

	count: INTEGER

	index: INTEGER

	item: ZSTRING

	joined: ZSTRING
		local
			is_shared: BOOLEAN
		do
			is_shared := is_shared_item
			is_shared_item := True
			create Result.make (file.count)
			from start until after loop
				if index > 1 then
					Result.append_character ('%N')
				end
				Result.append (item)
				forth
			end
			is_shared_item := is_shared
		end

	new_cursor: EL_LINE_SOURCE_ITERATION_CURSOR
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

feature -- Conversion

	list: EL_ZSTRING_LIST
			--
		local
			is_shared: BOOLEAN
		do
			is_shared := is_shared_item
			is_shared_item := False
			create Result.make_empty
			from start until after loop
				Result.extend (item)
				forth
			end
			is_shared_item := is_shared
		end

feature -- Cursor movement

	forth
			-- Move to next position
		require else
			file_is_open: is_open
		do
			if file = default_file then
				index := count

			elseif file.end_of_file then
				if not is_file_external then
					file.close
				end
			else
				file.read_line
				update_item
				count := count + 1
			end
			index := index + 1
		end

	start
			-- Move to first position if any.
		do
			if file = default_file then
				count := index + 1
			else
				open_at_start
				count := 0
				if file.off then
					index := 1
					item.wipe_out
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
			file.go (0)
		end

feature {NONE} -- Unused

	finish
			-- Move to last position.
		do
		end

feature {EL_LINE_SOURCE_ITERATION_CURSOR} -- Implementation

	default_file: PLAIN_TEXT_FILE
		deferred
		end

	update_item
		deferred
		end

feature {NONE} -- Internal attributes

	file: like default_file

end
