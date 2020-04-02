note
	description: "[
		Interface to class `TagLib::ID3v2::CommentsFrame'
		
			#include mpeg/id3v2/frames/commentsframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-02 12:27:31 GMT (Thursday 2nd April 2020)"
	revision: "7"

class
	TL_COMMENTS_ID3_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Initialization

	frozen cpp_new (encoding: NATURAL_8): POINTER
		-- explicit CommentsFrame(String::Type encoding = String::Latin1);
		external
			"C++ [new TagLib::ID3v2::CommentsFrame %"mpeg/id3v2/frames/commentsframe.h%"] (TagLib::String::Type)"
		end

feature -- Status query

	frozen cpp_conforms (frame: POINTER): BOOLEAN
		-- True if frame conforms to type `TagLib::ID3v2::CommentsFrame'
		external
			"C++ inline use <mpeg/id3v2/frames/commentsframe.h>"
		alias
			"[
				const TagLib::ID3v2::Frame* frame = (const TagLib::ID3v2::Frame*)$frame;
				return dynamic_cast<const TagLib::ID3v2::CommentsFrame*>(frame) != NULL
			]"
		end

feature {NONE} -- Access

	frozen cpp_find_by_description (tag, description: POINTER): POINTER
		-- static CommentsFrame *findByDescription(const Tag *tag, const String &d);
		external
			"C++ inline use <mpeg/id3v2/frames/commentsframe.h>"
		alias
			"[
				TagLib::String &description = *((TagLib::String*)$description);
				return TagLib::ID3v2::CommentsFrame::findByDescription ((TagLib::ID3v2::Tag*)$tag, description)
			]"
		end

	frozen cpp_get_description (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/frames/commentsframe.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v2::CommentsFrame*)$self)->description ())
			]"
		end

	frozen cpp_get_language (self, language_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/frames/commentsframe.h>"
		alias
			"[
				TagLib::ByteVector &language = *((TagLib::ByteVector *)$language_out);
				language.clear().append (((TagLib::ID3v2::CommentsFrame*)$self)->language ())
			]"
		end

feature {NONE} -- Element change

	frozen cpp_set_description (self, text: POINTER)
		-- void setDescription(const String &desc);
		external
			"C++ inline use <mpeg/id3v2/frames/commentsframe.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::ID3v2::CommentsFrame*)$self)->setDescription (text)
			]"
		end

	frozen cpp_set_language (self, language: POINTER)
		-- void setLanguage(const ByteVector &languageCode);
		-- Set the language using the 3 byte language code from http://en.wikipedia.org/wiki/ISO_639
		external
			"C++ inline use <mpeg/id3v2/frames/commentsframe.h>"
		alias
			"[
				const TagLib::ByteVector& language = *((const TagLib::ByteVector*)$language);
				((TagLib::ID3v2::CommentsFrame*)$self)->setLanguage (language)
			]"
		end

end
