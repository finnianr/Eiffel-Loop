note
	description: "Interface to class `TagLib::ID3v2::FrameList'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 15:58:19 GMT (Thursday 19th March 2020)"
	revision: "3"

class
	TL_ID3_FRAME_LIST_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Initialization

	frozen cpp_new: POINTER
			--
		external
			"C++ [new TagLib::ID3v2::FrameList %"mpeg/id3v2/id3v2tag.h%"] ()"
		end

feature {NONE} -- Disposal

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::ID3v2::FrameList %"mpeg/id3v2/id3v2tag.h%"] ()"
		end

feature {NONE} -- Access

	frozen cpp_get_first_text (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				TagLib::ID3v2::FrameList &list = *((TagLib::ID3v2::FrameList*)$self);
				if(!list.isEmpty())
					text.clear().append (list.front ()->toString());
				else
					text.clear();
			]"
		end

	frozen cpp_size (self_ptr: POINTER): INTEGER
		external
			"C++ [TagLib::ID3v2::FrameList %"mpeg/id3v2/id3v2tag.h%"] (): EIF_INTEGER"
		alias
			"size"
		end

feature {NONE} -- Status query

	frozen cpp_is_empty (self_ptr: POINTER): BOOLEAN
		external
			"C++ [TagLib::ID3v2::FrameList %"mpeg/id3v2/id3v2tag.h%"] (): EIF_BOOLEAN"
		alias
			"isEmpty"
		end

feature {NONE} -- Cursor movement

	frozen cpp_iterator_begin (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::ID3v2::FrameList::ConstIterator (((TagLib::ID3v2::FrameList*)$self)->begin())"
		end

	frozen cpp_iterator_end (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::ID3v2::FrameList::ConstIterator (((TagLib::ID3v2::FrameList*)$self)->end())"
		end

end
