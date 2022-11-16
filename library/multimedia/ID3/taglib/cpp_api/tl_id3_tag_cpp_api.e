note
	description: "[
		Interface to base class `TagLib::Tag'
		
			#include <tag.h>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	TL_ID3_TAG_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Access

	frozen cpp_get_album (self, text_out: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::Tag*)$self)->album ())
			]"
		end

	frozen cpp_get_artist (self, text_out: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::Tag*)$self)->artist ())
			]"
		end

	frozen cpp_get_genre (self, text_out: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::Tag*)$self)->genre ())
			]"
		end

	frozen cpp_get_comment (self, text_out: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::Tag*)$self)->comment ())
			]"
		end

	frozen cpp_get_title (self, text_out: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::Tag*)$self)->title ())
			]"
		end

	frozen cpp_track (self_ptr: POINTER): INTEGER
		--	unsigned int track()
		external
			"C++ [TagLib::Tag %"tag.h%"] (): EIF_INTEGER"
		alias
			"track"
		end

	frozen cpp_year (self_ptr: POINTER): INTEGER
		--	unsigned int track()
		external
			"C++ [TagLib::Tag %"tag.h%"] (): EIF_INTEGER"
		alias
			"year"
		end

feature {NONE} -- Element change

	frozen cpp_set_album (self, text: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::Tag*)$self)->setAlbum (text)
			]"
		end

	frozen cpp_set_artist (self, text: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::Tag*)$self)->setArtist (text)
			]"
		end

	frozen cpp_set_comment (self, text: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::Tag*)$self)->setComment (text)
			]"
		end

	frozen cpp_set_genre (self, text: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::Tag*)$self)->setGenre (text)
			]"
		end

	frozen cpp_set_title (self, text: POINTER)
		external
			"C++ inline use <tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::Tag*)$self)->setTitle (text)
			]"
		end

	frozen cpp_set_track (self_ptr: POINTER; track: INTEGER)
		--	void setTrack(unsigned int i)
		external
			"C++ [TagLib::Tag %"tag.h%"] (unsigned int)"
		alias
			"setTrack"
		end

	frozen cpp_set_year (self_ptr: POINTER; year: INTEGER)
		--	void setYear(unsigned int i)
		external
			"C++ [TagLib::Tag %"tag.h%"] (unsigned int)"
		alias
			"setYear"
		end

end