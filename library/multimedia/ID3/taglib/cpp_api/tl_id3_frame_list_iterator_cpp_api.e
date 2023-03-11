note
	description: "[
		Interface to class `TagLib::ID3v2::FrameList::ConstIterator'
		
			#include mpeg/id3v2/id3v2tag.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:55 GMT (Friday 10th March 2023)"
	revision: "7"

class
	TL_ID3_FRAME_LIST_ITERATOR_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Externals

	frozen cpp_after (iterator, it_end: POINTER): BOOLEAN
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"[
				TagLib::ID3v2::FrameList::ConstIterator&
					iterator = *(TagLib::ID3v2::FrameList::ConstIterator*)$iterator,
					end = *(TagLib::ID3v2::FrameList::ConstIterator*)$it_end;
				return iterator == end
			]"
		end

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::ID3v2::FrameList::ConstIterator %"mpeg/id3v2/id3v2tag.h%"] ()"
		end

	frozen cpp_item (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"**((TagLib::ID3v2::FrameList::ConstIterator*)$self)"
		end

	frozen cpp_get_frame_id (self, id_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"[
				TagLib::ByteVector id = (**((TagLib::ID3v2::FrameList::ConstIterator*)$self))->frameID ();
				TagLib::ByteVector &id_out = *((TagLib::ByteVector *)$id_out);
				id_out.clear().append (id)
			]"
		end

	frozen cpp_next (self: POINTER)
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"(*((TagLib::ID3v2::FrameList::ConstIterator*)$self))++"
		end

end