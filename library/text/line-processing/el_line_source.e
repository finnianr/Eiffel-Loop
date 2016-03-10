note
	description: "Summary description for {EL_LINE_SOURCE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

deferred class
	EL_LINE_SOURCE [F -> FILE]

inherit
	EL_LINEAR [EL_ASTRING]
		redefine
			default_create
		end

	ITERABLE [EL_ASTRING]
		undefine
			default_create
		end

	EL_ENCODEABLE_AS_TEXT
		undefine
			default_create
		redefine
			set_encoding
		end

feature {NONE} -- Initialization

	default_create
			--
		do
			create item.make_empty
			set_encoding (Encoding_iso_8859, 1)
		end

	make (a_source: F)
		do
			default_create
			source := a_source
		end

feature -- Access

	item: EL_ASTRING

	index: INTEGER

	count: INTEGER

	new_cursor: EL_LINE_SOURCE_ITERATION_CURSOR [F]
			--
		do
			create Result.make (Current)
			Result.start
		end

	source_copy: F
		deferred
		end

feature -- Cursor movement

	start
			-- Move to first position if any.
		do
			if source.is_open_read then
				source.close
			end
			source.open_read
			count := 0
			index := 0
			forth
		end

	forth
			-- Move to next position
		require else
			file_is_open: is_open
		do
			if source.after then
				close
			else
				item := next_line (source)
				count := count + 1
			end
			index := index + 1
		end

feature -- Element change

	set_encoding (a_type: like encoding_type a_encoding: like encoding)
			--
		do
			Precursor (a_type, a_encoding)
			if encoding_type ~ Encoding_ISO_8859 then
				inspect encoding
					when 1 then
						create {EL_LATIN_1_LINE_DECODER [F]} decoder
				else
					create {EL_LATIN_LINE_DECODER [F]} decoder
				end

			elseif encoding_type ~ Encoding_utf then
				if encoding = 8 then
					create {EL_UTF_8_LINE_DECODER [F]} decoder

				end
			end
		end

feature -- Status setting

	close
			--
		do
			if close_on_after then
				source.close
			end
		end

feature -- Status query

	is_open: BOOLEAN
			--
		do
			Result := source.is_open_read
		end

	after: BOOLEAN
			-- Is there no valid position to the right of current one?
		do
			Result := index = count + 1
		end

	is_empty: BOOLEAN
			-- Is there no element?
		do
			Result := source.is_empty
		end

	close_on_after: BOOLEAN

feature {NONE} -- Unused

	finish
			-- Move to last position.
		do
		end

feature {EL_LINE_SOURCE_ITERATION_CURSOR} -- Implementation

	next_line (a_source: F): EL_ASTRING
		do
			decoder.set_line_from_file (a_source)
			Result := decoder.line
		end

	decoder: EL_LINE_DECODER [F]

	source: F

end
