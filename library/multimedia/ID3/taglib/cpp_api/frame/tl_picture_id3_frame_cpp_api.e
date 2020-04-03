note
	description: "[
		Interface to class `TagLib::ID3v2::AttachedPictureFrame'
		
			#include mpeg/id3v2/frames/attachedpictureframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-15 11:50:27 GMT (Sunday 15th March 2020)"
	revision: "7"

class
	TL_PICTURE_ID3_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Initialization

	frozen cpp_new_empty: POINTER
		-- TagLib::ID3v2::AttachedPictureFrame();
		external
			"C++ [new TagLib::ID3v2::AttachedPictureFrame %"mpeg/id3v2/frames/attachedpictureframe.h%"] ()"
		end

feature {NONE} -- Implemenation

	frozen cpp_conforms (frame: POINTER): BOOLEAN
		-- True if frame conforms to type `TagLib::ID3v2::AttachedPictureFrame'
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"[
				const TagLib::ID3v2::Frame* frame = (const TagLib::ID3v2::Frame*)$frame;
				return dynamic_cast<const TagLib::ID3v2::AttachedPictureFrame*>(frame) != NULL
			]"
		end

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::ID3v2::AttachedPictureFrame %"mpeg/id3v2/frames/attachedpictureframe.h%"] ()"
		end

feature {NONE} -- Access

	frozen cpp_get_description (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v2::AttachedPictureFrame*)$self)->description ())
			]"
		end

	frozen cpp_get_mime_type (self, text_out: POINTER)
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v2::AttachedPictureFrame*)$self)->mimeType ())
			]"
		end

	frozen cpp_picture (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"new TagLib::ByteVector (((TagLib::ID3v2::AttachedPictureFrame*)$self)->picture ())"
		end

	frozen cpp_type_enum (self: POINTER): NATURAL_8
		external
			"C++ [TagLib::ID3v2::AttachedPictureFrame %"mpeg/id3v2/frames/attachedpictureframe.h%"] (): EIF_NATURAL_8"
		alias
			"type"
		end

feature {NONE} -- Element change

	frozen cpp_set_description (self, text: POINTER)
		-- void setDescription(const String &desc);
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text);
				((TagLib::ID3v2::AttachedPictureFrame*)$self)->setDescription (text)
			]"
		end

	frozen cpp_set_mime_type (self, str: POINTER)
		-- void setMimeType(const String &m);
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"[
				TagLib::String &mime_type = *((TagLib::String*)$str);
				((TagLib::ID3v2::AttachedPictureFrame*)$self)->setMimeType (mime_type)
			]"
		end

	frozen cpp_set_picture (self, data: POINTER)
		-- void AttachedPictureFrame::setPicture(const ByteVector &p)
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"[
				const TagLib::ByteVector& picture = *((const TagLib::ByteVector*)$data);
				((TagLib::ID3v2::AttachedPictureFrame*)$self)->setPicture (picture)
			]"
		end

	frozen cpp_set_type (self: POINTER; a_type: NATURAL_8)
		-- void setType(Type t);
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"[
				TagLib::ID3v2::AttachedPictureFrame::Type type = (TagLib::ID3v2::AttachedPictureFrame::Type)$a_type;
				((TagLib::ID3v2::AttachedPictureFrame*)$self)->setType (type)
			]"
		end
end

