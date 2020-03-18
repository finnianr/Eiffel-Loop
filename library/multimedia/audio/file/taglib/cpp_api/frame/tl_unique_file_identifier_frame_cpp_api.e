note
	description: "[
		Interface to class `TagLib::ID3v2::UniqueFileIdentifierFrame'

			#include mpeg/id3v2/frames/uniquefileidentifierframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-18 18:10:02 GMT (Wednesday 18th March 2020)"
	revision: "1"

class
	TL_UNIQUE_FILE_IDENTIFIER_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Initialization

	frozen cpp_new (owner, id: POINTER): POINTER
			-- UniqueFileIdentifierFrame(const String &owner, const ByteVector &id);

			-- Creates a unique file identifier frame with the owner owner and
			-- the identification id.
		external
			"C++ inline use <mpeg/id3v2/frames/uniquefileidentifierframe.h>"
		alias
			"[
				TagLib::ByteVector &id = *((TagLib::ByteVector*) $id);
				TagLib::String &owner = *((TagLib::String*) $owner);
				return new TagLib::ID3v2::UniqueFileIdentifierFrame (owner, id)
			]"
		end

feature {NONE} -- Access

	frozen cpp_get_identifier (self, id_out: POINTER)
		-- ByteVector identifier() const;
		external
			"C++ inline use <mpeg/id3v2/frames/uniquefileidentifierframe.h>"
		alias
			"[
				TagLib::ByteVector &id_out = *((TagLib::ByteVector *)$id_out);
				id_out.clear().append (((TagLib::ID3v2::UniqueFileIdentifierFrame*)$self)->identifier ())
			]"
		end

	frozen cpp_get_owner (self, text_out: POINTER)
		-- String owner() const;
		external
			"C++ inline use <mpeg/id3v2/frames/uniquefileidentifierframe.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append (((TagLib::ID3v2::UniqueFileIdentifierFrame*)$self)->owner ())
			]"
		end

feature {NONE} -- Element change

	frozen cpp_set_identifier (self, id: POINTER)
		--  void setIdentifier(const ByteVector &v);
		external
			"C++ inline use <mpeg/id3v2/frames/uniquefileidentifierframe.h>"
		alias
			"[
				TagLib::ByteVector &id = *((TagLib::ByteVector*)$id);
				((TagLib::ID3v2::UniqueFileIdentifierFrame*)$self)->setIdentifier (id)
			]"
		end

	frozen cpp_set_owner (self, owner: POINTER)
		--  void setOwner(const String &s);
		external
			"C++ inline use <mpeg/id3v2/frames/uniquefileidentifierframe.h>"
		alias
			"[
				TagLib::String &owner = *((TagLib::String*) $owner);
				((TagLib::ID3v2::UniqueFileIdentifierFrame*)$self)->setOwner (owner)
			]"
		end

feature {NONE} -- Status query

	frozen cpp_conforms (frame: POINTER): BOOLEAN
		-- True if frame conforms to type `TagLib::ID3v2::UniqueFileIdentifierFrame'
		external
			"C++ inline use <mpeg/id3v2/frames/uniquefileidentifierframe.h>"
		alias
			"[
				const TagLib::ID3v2::Frame* frame = (const TagLib::ID3v2::Frame*)$frame;
				return dynamic_cast<const TagLib::ID3v2::UniqueFileIdentifierFrame*>(frame) != NULL
			]"
		end
end
