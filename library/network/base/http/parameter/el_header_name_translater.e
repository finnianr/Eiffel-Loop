note
	description: "Translate HTTP header names to Eiffel convention"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-14 15:11:47 GMT (Tuesday 14th June 2022)"
	revision: "1"

class
	EL_HEADER_NAME_TRANSLATER

inherit
	EL_KEBAB_CASE_TRANSLATER
		rename
			make as make_kebab,
			make_title as make
		redefine
			exported, Title_uppercase_word_exception_set
		end

create
	make

feature -- Conversion

	exported (eiffel_name: STRING): STRING
		-- `eiffel_name' exported to a foreign naming convention
		local
			s: EL_STRING_8_ROUTINES
		do
			if s.same_caseless (eiffel_name, Etag) then
				Result := Etag
			else
				Result := Precursor (eiffel_name)
			end
		end

feature {NONE} -- Constants

	Title_uppercase_word_exception_set: EL_HASH_SET [STRING]
		local
			list: EL_STRING_8_LIST
		once
			list := "http2, id, im, md5, te, p3p, www"
			Result := list.to_array
		end

	Etag: STRING = "ETag"
end