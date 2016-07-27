note
	description: "[
		Reads encoded lines using set encoding, UTF-8 by default.
		If a UTF-8 BOM is detected the encoding changes accordingly.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-05 5:13:47 GMT (Tuesday 5th July 2016)"
	revision: "7"

deferred class
	EL_LINE_SOURCE [F -> FILE]

inherit
	EL_LINEAR [ZSTRING]

	ITERABLE [ZSTRING]

	EL_ENCODEABLE_AS_TEXT
		redefine
			set_encoding
		end

	EL_SHARED_ZCODEC_FACTORY

	EL_MODULE_UTF

feature {NONE} -- Initialization

	make_default
			--
		do
			create item.make_empty
			set_utf_encoding (8)
		end

	make (a_source: F)
		do
			make_default
			source := a_source
			is_source_external := True
			check_for_bom
		end

feature -- Access

	item: ZSTRING

	index: INTEGER

	count: INTEGER

	joined: ZSTRING
		do
			create Result.make (source.count)
			from start until after loop
				if index > 1 then
					Result.append_character ('%N')
				end
				Result.append (item)
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

	has_utf_8_bom: BOOLEAN
		-- True if source has UTF-8 byte order mark		

	is_open: BOOLEAN
			--
		do
			Result := source.is_open_read
		end

	is_empty: BOOLEAN
			-- Is there no element?
		do
			Result := source.is_empty
		end

	is_source_external: BOOLEAN
		-- True if source is managed externally to object

feature -- Conversion

	list: EL_ZSTRING_LIST
			--
		do
			create Result.make_empty
			from start until after loop
				Result.extend (item)
				forth
			end
		end

feature -- Cursor movement

	start
			-- Move to first position if any.
		do
			open_at_start
			count := 0
			if source.off then
				index := 1
				create item.make_empty
			else
				index := 0
				forth
			end
		end

	forth
			-- Move to next position
		require else
			file_is_open: is_open
		do
			if source.end_of_file then
				if not is_source_external then
					source.close
				end
			else
				item := next_line (source)
				count := count + 1
			end
			index := index + 1
		end

feature -- Element change

	set_encoding (a_type: like encoding_type; a_encoding: like encoding)
			--
		do
			Precursor (a_type, a_encoding)
			set_decoder
		end

feature -- Status setting

	close
			--
		do
			if source.is_open_read then
				source.close
			end
		end

	open_at_start
		do
			if not source.is_open_read then
				source.open_read
			end
			if has_utf_8_bom then
				source.go (3)
			else
				source.go (0)
			end
		end

feature {NONE} -- Unused

	finish
			-- Move to last position.
		do
		end

feature {EL_LINE_SOURCE_ITERATION_CURSOR} -- Implementation

	check_for_bom
		local
			is_open_read: BOOLEAN
		do
			is_open_read := source.is_open_read
			open_at_start
			if source.count >= 3 then
				source.read_stream (3)
				has_utf_8_bom := source.last_string ~ UTF.Utf_8_bom_to_string_8
				if has_utf_8_bom then
					set_utf_encoding (8)
				end
			end
			if not is_open_read then
				source.close
			end
		end

	next_line (a_source: F): ZSTRING
		do
			decoder.set_line_from_file (a_source)
			Result := decoder.line
		end

	set_decoder
		do
			if encoding_type = Encoding_ISO_8859 then
				create {EL_ENCODED_LINE_READER [F]} decoder.make (new_iso_8859_codec (encoding))

			elseif encoding_type = Encoding_windows then
				create {EL_ENCODED_LINE_READER [F]} decoder.make (new_windows_codec (encoding))

			elseif encoding_type = Encoding_utf then
				if encoding = 8 then
					create {EL_UTF_8_ENCODED_LINE_READER [F]} decoder

				end
			end
		end

	decoder: EL_LINE_READER [F]

	source: F

end
