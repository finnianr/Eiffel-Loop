note
	description: "[
		Interface to class `TagLib::ID3v2::Tag'
		
			#include <mpeg/id3v2/id3v2tag.h>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 18:06:26 GMT (Monday 11th November 2019)"
	revision: "7"

class
	TL_ID3_V2_TAG_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_get_first_frame_text (tag, id, text_out: POINTER)
		-- look up frame list with `id' and set `text_out' to the first item text
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"[
				const TagLib::ByteVector frame_id = *((const TagLib::ByteVector*)$id);
				TagLib::String *text = (TagLib::String*)$text_out;
				const TagLib::ID3v2::FrameList &list = ((TagLib::ID3v2::Tag*)$tag)->frameList (frame_id);
				if(list.isEmpty())
					text->clear();
				else
					text->clear().append (list.front ()->toString());
			]"
		end

	frozen cpp_frame_list (tag, id: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"[
				const TagLib::ByteVector frame_id = *((const TagLib::ByteVector*)$id);
				return new TagLib::ID3v2::FrameList (((TagLib::ID3v2::Tag*)$tag)->frameList (frame_id))
			]"
		end

	frozen cpp_frame_list_begin (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::ID3v2::FrameList::ConstIterator (((TagLib::ID3v2::Tag*)$tag)->frameList().begin())"
		end

	frozen cpp_frame_list_end (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::ID3v2::FrameList::ConstIterator (((TagLib::ID3v2::Tag*)$tag)->frameList().end())"
		end

	frozen cpp_frame_count (tag: POINTER): INTEGER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"((TagLib::ID3v2::Tag*)$tag)->frameList().size()"
		end

	frozen cpp_get_comment (tag, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v2::Tag*)$tag)->comment ())
			]"
		end

	frozen cpp_header (self_ptr: POINTER): POINTER
		--	Header *header()
		external
			"C++ [TagLib::ID3v2::Tag %"mpeg/id3v2/id3v2tag.h%"] (): EIF_POINTER"
		alias
			"header"
		end

	frozen cpp_title (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::String (((TagLib::ID3v2::Tag*)$tag)->title ())"
		end

end
