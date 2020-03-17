note
	description: "Interface to class `TagLib::ID3v1::Tag'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-17 18:09:37 GMT (Tuesday 17th March 2020)"
	revision: "6"

class
	TL_ID3_V1_TAG_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Access

	frozen cpp_get_album (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v1::Tag*)$self)->album ())
			]"
		end

	frozen cpp_get_artist (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v1::Tag*)$self)->artist ())
			]"
		end

	frozen cpp_get_comment (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v1::Tag*)$self)->comment ())
			]"
		end

	frozen cpp_get_title (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v1::Tag*)$self)->title ())
			]"
		end

feature {NONE} -- Element change

	frozen cpp_set_album (self, text: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::ID3v1::Tag*)$self)->setAlbum (text)
			]"
		end

	frozen cpp_set_artist (self, text: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::ID3v1::Tag*)$self)->setArtist (text)
			]"
		end

	frozen cpp_set_title (self, text: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::ID3v1::Tag*)$self)->setTitle (text)
			]"
		end
end
