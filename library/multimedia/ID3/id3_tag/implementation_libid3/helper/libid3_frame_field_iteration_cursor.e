note
	description: "Libid3 frame field iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	LIBID3_FRAME_FIELD_ITERATION_CURSOR

inherit
	EL_CPP_ITERATION_CURSOR [LIBID3_FRAME_FIELD]
		rename
			make as make_cursor,
			cpp_next as cpp_iterator_next
		end

	LIBID3_ID3_FRAME_ITERATOR_CPP_API

	ID3_SHARED_FRAME_FIELD_TYPES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_frame: LIBID3_FRAME; cpp_iterator: POINTER)
			--
		do
			frame := a_frame
			make_cursor (cpp_iterator)
		end

feature -- Access

	item: LIBID3_FRAME_FIELD
		--	ID3_ENUM(ID3_FieldID) {
		--  00 ID3FN_NOFIELD = 0,    /**< No field */
		--  01 ID3FN_TEXTENC,        /**< Text encoding (unicode or ASCII) */
		--  02 ID3FN_TEXT,           /**< Text field */
		--  03 ID3FN_URL,            /**< A URL */
		--  04 ID3FN_DATA,           /**< Data field */
		--  05 ID3FN_DESCRIPTION,    /**< Description field */
		--  06 ID3FN_OWNER,          /**< Owner field */
		--  07 ID3FN_EMAIL,          /**< Email field */
		--  08 ID3FN_RATING,         /**< Rating field */
		--  09 ID3FN_FILENAME,       /**< Filename field */
		--  10 ID3FN_LANGUAGE,       /**< Language field */
		--  11 ID3FN_PICTURETYPE,    /**< Picture type field */
		--  12 ID3FN_IMAGEFORMAT,    /**< Image format field */
		--  13 ID3FN_MIMETYPE,       /**< Mimetype field */
		--  14 ID3FN_COUNTER,        /**< Counter field */
		--  15 ID3FN_ID,             /**< Identifier/Symbol field */
		--  16 ID3FN_VOLUMEADJ,      /**< Volume adjustment field */
		--  17 ID3FN_NUMBITS,        /**< Number of bits field */
		--  18 ID3FN_VOLCHGRIGHT,    /**< Volume chage on the right channel */
		--  19 ID3FN_VOLCHGLEFT,     /**< Volume chage on the left channel */
		--  20 ID3FN_PEAKVOLRIGHT,   /**< Peak volume on the right channel */
		--  21 ID3FN_PEAKVOLLEFT,    /**< Peak volume on the left channel */
		--  22 ID3FN_TIMESTAMPFORMAT,/**< SYLT Timestamp Format */
		--  23 ID3FN_CONTENTTYPE,    /**< SYLT content type */
		--  24 ID3FN_LASTFIELDID     /**< Last field placeholder */
		--	};
		local
			field_id, list_count: INTEGER
		do
			field_id := {LIBID3_ID3_FIELD_CPP_API}.cpp_id (cpp_item)
			list_count := {LIBID3_ID3_FIELD_CPP_API}.cpp_text_item_count (cpp_item)
			-- globals.h
			inspect field_id -- ID3_ENUM(ID3_FieldID)
				when 1 then -- ID3FN_TEXTENC
					create {LIBID3_ENCODING_FIELD} Result.make (cpp_item)
				when 2 then -- ID3FN_TEXT
					if list_count > 1 then
						create {LIBID3_STRING_LIST_FIELD} Result.make (cpp_item, frame.encoding)
					else
						create {LIBID3_STRING_FIELD} Result.make (cpp_item, frame.encoding)
					end
				when 3 then -- ID3FN_URL
					create {LIBID3_LATIN_1_STRING_FIELD} Result.make (cpp_item)

				when 4 then -- ID3FN_DATA
					create {LIBID3_BINARY_DATA_FIELD} Result.make (cpp_item)
				when 5 then -- ID3FN_DESCRIPTION
					create {LIBID3_DESCRIPTION_FIELD} Result.make (cpp_item, frame.encoding)
				when 6, 7 then -- ID3FN_OWNER, ID3FN_EMAIL
					create {LIBID3_LATIN_1_STRING_FIELD} Result.make (cpp_item)
				when 8 then -- ID3FN_RATING
					create {LIBID3_INTEGER_FIELD} Result.make (cpp_item)
				when 9 then -- ID3FN_FILENAME
					create {LIBID3_STRING_FIELD} Result.make (cpp_item, frame.encoding)
				when 10 then -- ID3FN_LANGUAGE
					create {LIBID3_LANGUAGE_FIELD} Result.make (cpp_item)
				when 11 then -- ID3FN_PICTURETYPE,
					create {LIBID3_INTEGER_FIELD} Result.make (cpp_item)

				when 12, 13 then -- ID3FN_IMAGEFORMAT, ID3FN_MIMETYPE
					-- There must be a bug in libid3 because these fields are empty!
					create {LIBID3_LATIN_1_STRING_FIELD} Result.make (cpp_item)
				when 14 .. 17 then -- ID3FN_COUNTER, ID3FN_ID, ID3FN_VOLUMEADJ, ID3FN_NUMBITS
					create {LIBID3_INTEGER_FIELD} Result.make (cpp_item)
				when 18 .. 21 then -- ID3FN_VOLCHGRIGHT, ID3FN_VOLCHGLEFT, ID3FN_PEAKVOLRIGHT, ID3FN_PEAKVOLLEFT
					create {LIBID3_INTEGER_FIELD} Result.make (cpp_item)

				when 22, 23 then -- ID3FN_TIMESTAMPFORMAT, ID3FN_CONTENTTYPE
					create {LIBID3_INTEGER_FIELD} Result.make (cpp_item)

			else
				create {LIBID3_DEFAULT_FIELD} Result.make (cpp_item)
			end
		end

feature {NONE} -- Internal attributes

	frame: LIBID3_FRAME

end