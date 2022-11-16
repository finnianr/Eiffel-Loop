note
	description: "[
		Interface to class `TagLib::ID3v2::Frame'
		
			#include mpeg/id3v2/id3v2frame.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	TL_ID3_TAG_FRAME_CPP_API

inherit
	EL_CPP_API

feature {TL_ID3_FRAME_LIST_ITERATOR_CPP_API} -- Access

	frozen cpp_frame_id (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2frame.h>"
		alias
			"new TagLib::ByteVector (((TagLib::ID3v2::Frame*)$self)->frameID ())"
		end

	frozen cpp_get_frame_id (self, id_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/id3v2frame.h>"
		alias
			"[
				TagLib::ByteVector &id_out = *((TagLib::ByteVector *)$id_out);
				id_out.clear().append (((TagLib::ID3v2::Frame*)$self)->frameID ())
			]"
		end

	frozen cpp_get_string (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/id3v2frame.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append(((TagLib::ID3v2::Frame*)$self)->toString ())
			]"
		end

feature {NONE} -- Element change

	frozen cpp_set_text (self, text: POINTER)
		-- virtual void setText(const String &text);

		-- If the frame type supports multiple text encodings, this will not
      -- change the text encoding of the frame; the string will be converted to
      -- that frame's encoding.  Please use the specific APIs of the frame types
      -- to set the encoding if that is desired.

		external
			"C++ inline use <mpeg/id3v2/id3v2frame.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::ID3v2::Frame*)$self)->setText (text)
			]"
		end

end