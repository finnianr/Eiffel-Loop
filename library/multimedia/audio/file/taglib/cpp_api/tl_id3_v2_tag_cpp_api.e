note
	description: "[
		Interface to class `TagLib::ID3v2::Tag'
		
			#include <mpeg/id3v2/id3v2tag.h>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-18 18:16:43 GMT (Wednesday 18th March 2020)"
	revision: "9"

class
	TL_ID3_V2_TAG_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Access

	frozen cpp_frame_count (tag: POINTER): INTEGER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"((TagLib::ID3v2::Tag*)$tag)->frameList().size()"
		end

	frozen cpp_frame_list (tag, frame_id: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"[
				const TagLib::ByteVector frame_id = *((const TagLib::ByteVector*) $frame_id);
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

	frozen cpp_get_comment (tag, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v2::Tag*)$tag)->comment ())
			]"
		end

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

	frozen cpp_header (self_ptr: POINTER): POINTER
		--	Header *header()
		external
			"C++ [TagLib::ID3v2::Tag %"mpeg/id3v2/id3v2tag.h%"] (): EIF_POINTER"
		alias
			"header"
		end

feature {NONE} -- Element change

	frozen cpp_add_frame (self_ptr, frame_ptr: POINTER)
		-- Add a frame to the tag.  At this point the tag takes ownership of
		-- the frame and will handle freeing its memory.
		-- note Using this method will invalidate any pointers on the list returned by frameList()

 		-- void addFrame(Frame *frame);
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"((TagLib::ID3v2::Tag*)$self_ptr)->addFrame ((TagLib::ID3v2::Frame*)$frame_ptr)"
		end

feature {NONE} -- Removal

	frozen cpp_remove_frame (self_ptr, frame_ptr: POINTER)
		-- void removeFrame(Frame *frame, bool del = true);
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"((TagLib::ID3v2::Tag*)$self_ptr)->removeFrame ((TagLib::ID3v2::Frame*)$frame_ptr)"
		end

end
