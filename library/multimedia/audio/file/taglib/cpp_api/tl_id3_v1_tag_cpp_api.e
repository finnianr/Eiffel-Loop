note
	description: "Interface to class `TagLib::ID3v1::Tag'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 11:11:35 GMT (Monday 11th November 2019)"
	revision: "5"

class
	TL_ID3_V1_TAG_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_get_album (tag, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v1::Tag*)$tag)->album ())
			]"
		end

	frozen cpp_get_artist (tag, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v1::Tag*)$tag)->artist ())
			]"
		end

	frozen cpp_get_comment (tag, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v1::Tag*)$tag)->comment ())
			]"
		end

	frozen cpp_get_title (tag, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v1::Tag*)$tag)->title ())
			]"
		end
end
