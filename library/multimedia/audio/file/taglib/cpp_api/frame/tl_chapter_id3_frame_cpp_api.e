note
	description: "[
		Interface to class `TagLib::ID3v2::ChapterFrame'
		
			#include mpeg/id3v2/frames/chapterframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-18 16:59:29 GMT (Wednesday 18th March 2020)"
	revision: "4"

class
	TL_CHAPTER_ID3_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Status query

	frozen cpp_conforms (frame: POINTER): BOOLEAN
		-- True if frame conforms to type `TagLib::ID3v2::ChapterFrame'
		external
			"C++ inline use <mpeg/id3v2/frames/chapterframe.h>"
		alias
			"[
				const TagLib::ID3v2::Frame* frame = (const TagLib::ID3v2::Frame*)$frame;
				return dynamic_cast<const TagLib::ID3v2::ChapterFrame*>(frame) != NULL
			]"
		end

feature {NONE} -- Measurement

	frozen cpp_start_time (self: POINTER): NATURAL
		-- unsigned int startTime() const;
		external
			"C++ [TagLib::ID3v2::ChapterFrame %"mpeg/id3v2/frames/chapterframe.h%"] (): EIF_NATURAL"
		alias
			"startTime"
		end

end
