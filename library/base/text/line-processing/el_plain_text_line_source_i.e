note
	description: "[
		Reads encoded lines using set encoding, UTF-8 by default.
		If a UTF-8 BOM is detected the encoding changes accordingly.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-05 18:18:40 GMT (Tuesday 5th March 2019)"
	revision: "5"

deferred class
	EL_PLAIN_TEXT_LINE_SOURCE_I

inherit
	EL_LINEAR [ZSTRING]

	ITERABLE [ZSTRING]

	EL_ENCODEABLE_AS_TEXT
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make (a_file: like file)
		do
			make_default
			file := a_file
			is_file_external := True
		end

	make_default
			--
		do
			Precursor
			create internal_item.make_empty
			file := default_file
		end

feature -- Access

	count: INTEGER

	index: INTEGER

	item: ZSTRING
		do
			if is_shared_item then
				Result := internal_item
			else
				Result := internal_item.twin
			end
		end

	joined: ZSTRING
		do
			create Result.make (file.count)
			from start until after loop
				if index > 1 then
					Result.append_character ('%N')
				end
				Result.append (internal_item)
				forth
			end
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
		do
			create Result.make_empty
			from start until after loop
				Result.extend (internal_item.twin)
				forth
			end
		end

feature -- Cursor movement

	forth
			-- Move to next position
		require else
			file_is_open: is_open
		do
			if file.end_of_file then
				if not is_file_external then
					file.close
				end
			else
				file.read_line
				update (internal_item)
				count := count + 1
			end
			index := index + 1
		end

	start
			-- Move to first position if any.
		do
			open_at_start
			count := 0
			if file.off then
				index := 1
				internal_item.wipe_out
			else
				index := 0
				forth
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

	enable_shared_item
		-- when enabled `internal_item' is returned from `item' without twinning
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

	update (line: like item)
		deferred
		end

feature {NONE} -- Internal attributes

	file: like default_file

	internal_item: ZSTRING

end
