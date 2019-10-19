note
	description: "Libid3 constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	LIBID3_CONSTANTS

feature {NONE} -- Field types

	FN_data: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_DATA"
		end

feature {NONE} -- String fields

	FN_description: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_DESCRIPTION"
		end

	FN_text: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_TEXT"
		end

	FN_filename: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_FILENAME"
		end

feature {NONE} -- Latin-1 fields

	FN_language: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_LANGUAGE"
		end

	FN_email: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_EMAIL"
		end

	FN_image_format: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_IMAGEFORMAT"
		end

	FN_mime_type: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_MIMETYPE"
		end

	FN_owner: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_OWNER"
		end

	FN_url: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_URL"
		end

feature {NONE} -- Integer fields

	FN_counter: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_COUNTER"
		end

	FN_id: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_ID"
		end

	FN_text_encoding: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_TEXTENC"
		end

	FN_time_stamp_format: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_TIMESTAMPFORMAT"
		end

	FN_content_type: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_CONTENTTYPE"
		end

	FN_numbits: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_NUMBITS"
		end

	FN_picture_type: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_PICTURETYPE"
		end

	FN_rating: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_RATING"
		end

	FN_volume_change_left: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_VOLCHGLEFT"
		end

	FN_volume_change_right: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_VOLCHGRIGHT"
		end

	FN_peak_volume_left: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_PEAKVOLLEFT"
		end

	FN_peak_volume_right: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_PEAKVOLRIGHT"
		end

	FN_volume_adjust: INTEGER
         --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FN_VOLUMEADJ"
		end

feature {NONE} -- Field data types

	Field_type_binary: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FTY_BINARY"
		end

	Field_type_integer: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FTY_INTEGER"
		end

	Field_type_none: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FTY_NONE"
		end

	Field_type_text_string: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FTY_TEXTSTRING"
		end

feature {ID3_ENCODING_ENUM} -- Encoding types

	Encoding_ISO8859_1: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return  ID3TE_ISO8859_1"
		end

	Encoding_NONE: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TE_NONE"
		end

	Encoding_NUMENCODINGS: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TE_NUMENCODINGS"
		end

	Encoding_UTF16: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TE_UTF16"
		end

	Encoding_UTF16BE: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TE_UTF16BE"
		end

	Encoding_UTF8: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TE_UTF8"
		end

feature {NONE} -- Encoding major types

	Encoding_ASCII: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TE_ASCII"
		end

	Encoding_UNICODE: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TE_UNICODE"
		end

feature {NONE} -- Major versions

	ID3_all: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TT_ALL"
		end

	ID3_none: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TT_NONE"
		end

	ID3_v1: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TT_ID3V1"
		end

	ID3_v2: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3TT_ID3V2"
		end

feature {NONE} -- Version specs

	ID3v1_0: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3V1_0"
		end

	ID3v1_1: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3V1_1"
		end

	ID3v2_2: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3V2_2_0"
		end

	ID3v2_21: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3V2_2_1"
		end

	ID3v2_3: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3V2_3_0"
		end

	ID3v2_unknown: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3V2_UNKNOWN"
		end

feature {NONE} -- Other

	FID_Year: INTEGER
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return ID3FID_YEAR"
		end

	Null_unicode: NATURAL_16
            --
		external
			"C++ inline use %"id3/tag.h%""
		alias
			"return NULL_UNICODE"
		end

	c_patch_version: INTEGER
			-- const char * const ID3LIB_VERSION
        external
            "C inline use %"id3/globals.h%""
        alias
        	"return ID3LIB_PATCH_VERSION"
        end

feature {NONE} -- Conversion

	Frame_id_table: HASH_TABLE [INTEGER, STRING]
		once
			create Result.make (Frame_codes.count)
			across Frame_codes as code loop
				Result [code.item] := code.cursor_index
			end

			-- Override Recording time to prevent some kind of bug leading to segment default.
			Result ["TDRC"] := FID_Year
		end

feature {NONE} -- Constants

	Frame_codes: ARRAY [STRING]
		once
			Result := <<
				"AENC", -- Audio encryption
				"APIC", -- Attached picture
				"ASPI", -- Audio seek point index
				"COMM", -- Comments
				"COMR", -- Commercial frame
				"ENCR", -- Encryption method registration
				"EQU2", -- Equalisation (2)
				"EQUA", -- Equalization
				"ETCO", -- Event timing codes
				"GEOB", -- General encapsulated object
				"GRID", -- Group identification registration
				"IPLS", -- Involved people list
				"LINK", -- Linked information
				"MCDI", -- Music CD identifier
				"MLLT", -- MPEG location lookup table
				"OWNE", -- Ownership frame
				"PRIV", -- Private frame
				"PCNT", -- Play counter
				"POPM", -- Popularimeter
				"POSS", -- Position synchronisation frame
				"RBUF", -- Recommended buffer size
				"RVA2", -- Relative volume adjustment (2)
				"RVAD", -- Relative volume adjustment
				"RVRB", -- Reverb
				"SEEK", -- Seek frame
				"SIGN", -- Signature frame
				"SYLT", -- Synchronized lyric/text
				"SYTC", -- Synchronized tempo codes
				"TALB", -- Album/Movie/Show title
				"TBPM", -- BPM (beats per minute)
				"TCOM", -- Composer
				"TCON", -- Content type
				"TCOP", -- Copyright message
				"TDAT", -- Date
				"TDEN", -- Encoding time
				"TDLY", -- Playlist delay
				"TDOR", -- Original release time
				"TDRC", -- Recording time
				"TDRL", -- Release time
				"TDTG", -- Tagging time
				"TIPL", -- Involved people list
				"TENC", -- Encoded by
				"TEXT", -- Lyricist/Text writer
				"TFLT", -- File type
				"TIME", -- Time
				"TIT1", -- Content group description
				"TIT2", -- Title/songname/content description
				"TIT3", -- Subtitle/Description refinement
				"TKEY", -- Initial key
				"TLAN", -- Language(s)
				"TLEN", -- Length
				"TMCL", -- Musician credits list
				"TMED", -- Media type
				"TMOO", -- Mood
				"TOAL", -- Original album/movie/show title
				"TOFN", -- Original filename
				"TOLY", -- Original lyricist(s)/text writer(s)
				"TOPE", -- Original artist(s)/performer(s)
				"TORY", -- Original release year
				"TOWN", -- File owner/licensee
				"TPE1", -- Lead performer(s)/Soloist(s)
				"TPE2", -- Band/orchestra/accompaniment
				"TPE3", -- Conductor/performer refinement
				"TPE4", -- Interpreted, remixed, or otherwise modified by
				"TPOS", -- Part of a set
				"TPRO", -- Produced notice
				"TPUB", -- Publisher
				"TRCK", -- Track number/Position in set
				"TRDA", -- Recording dates
				"TRSN", -- Internet radio station name
				"TRSO", -- Internet radio station owner
				"TSIZ", -- Size
				"TSOA", -- Album sort order
				"TSOP", -- Performer sort order
				"TSOT", -- Title sort order
				"TSRC", -- ISRC (international standard recording code)
				"TSSE", -- Software/Hardware and settings used for encoding
				"TSST", -- Set subtitle
				"TXXX", -- User defined text information
				"TYER", -- Year
				"UFID", -- Unique file identifier
				"USER", -- Terms of use
				"USLT", -- Unsynchronized lyric/text transcription
				"WCOM", -- Commercial information
				"WCOP", -- Copyright/Legal infromation
				"WOAF", -- Official audio file webpage
				"WOAR", -- Official artist/performer webpage
				"WOAS", -- Official audio source webpage
				"WORS", -- Official internet radio station homepage
				"WPAY", -- Payment
				"WPUB", -- Official publisher webpage
				"WXXX"    -- User defined URL link
			>>
			Result.compare_objects
		end

end
