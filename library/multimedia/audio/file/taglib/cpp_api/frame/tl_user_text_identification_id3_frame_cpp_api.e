note
	description: "[
		Interface to class `TagLib::ID3v2::UserTextIdentificationFrame'

			#include mpeg/id3v2/frames/textidentificationframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 17:25:07 GMT (Thursday 19th March 2020)"
	revision: "1"

class
	TL_USER_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Initialization

	frozen cpp_new (description, values: POINTER; encoding: NATURAL_8): POINTER
		-- UserTextIdentificationFrame(
		--		const String &description, const StringList &values,
		--		String::Type encoding = String::UTF8
		-- );
		external
			"C++ inline use <mpeg/id3v2/frames/textidentificationframe.h>"
		alias
			"[
				TagLib::String &description = *((TagLib::String *)$description);
				TagLib::StringList &values = *((TagLib::StringList *)$values);
				return new TagLib::ID3v2::UserTextIdentificationFrame (
					description, values, (TagLib::String::Type)$encoding
				)
			]"
		end

feature {NONE} -- Status query

	frozen cpp_conforms (frame: POINTER): BOOLEAN
		-- True if frame conforms to type `TagLib::ID3v2::UserTextIdentificationFrame'
		external
			"C++ inline use <mpeg/id3v2/frames/textidentificationframe.h>"
		alias
			"[
				const TagLib::ID3v2::Frame* frame = (const TagLib::ID3v2::Frame*)$frame;
				return dynamic_cast<const TagLib::ID3v2::UserTextIdentificationFrame*>(frame) != NULL
			]"
		end

feature {NONE} -- Access

	frozen cpp_field_list (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/frames/textidentificationframe.h>"
		alias
			"new TagLib::StringList (((TagLib::ID3v2::UserTextIdentificationFrame*)$self)->fieldList ())"
		end

	frozen cpp_get_description (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/frames/textidentificationframe.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v2::UserTextIdentificationFrame*)$self)->description ())
			]"
		end

feature {NONE} -- Element change

	frozen cpp_set_text_from_list (self, list: POINTER)
		-- void UserTextIdentificationFrame::setText(const StringList &fields)
		external
			"C++ inline use <mpeg/id3v2/frames/textidentificationframe.h>"
		alias
			"[
				TagLib::StringList &list = *((TagLib::StringList*)$list);
				((TagLib::ID3v2::UserTextIdentificationFrame*)$self)->setText (list)
			]"
		end

feature {TL_ID3_V2_TAG} -- Access

	frozen cpp_find_user_text_frame (tag, description: POINTER): POINTER
		-- static UserTextIdentificationFrame *find(Tag *tag, const String &description);
		external
			"C++ inline use <mpeg/id3v2/frames/textidentificationframe.h>"
		alias
			"[
				TagLib::String &description = *((TagLib::String*)$description);
				return TagLib::ID3v2::UserTextIdentificationFrame::find ((TagLib::ID3v2::Tag*)$tag, description)
			]"
		end

end
