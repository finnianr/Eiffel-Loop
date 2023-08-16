note
	description: "Translate HTTP header names to Eiffel convention"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-15 15:22:03 GMT (Tuesday 15th August 2023)"
	revision: "5"

class
	EL_HTTP_HEADER_NAME_TRANSLATER

inherit
	EL_KEBAB_CASE_TRANSLATER
		redefine
			exported, Default_case, Uppercase_exception_set_list
		end

create
	make

feature -- Conversion

	exported (eiffel_name: READABLE_STRING_8): STRING
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

	Default_case: NATURAL
		once
			Result := {EL_CASE}.title
		end

	Etag: STRING = "ETag"

	Uppercase_exception_set_list: STRING = "http2, id, im, md5, te, p3p, www"

end