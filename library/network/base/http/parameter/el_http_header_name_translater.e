note
	description: "Translate HTTP header names to Eiffel convention"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 12:23:08 GMT (Monday 21st April 2025)"
	revision: "7"

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
		do
			if super_readable_8 (eiffel_name).same_caseless (Etag) then
				Result := Etag
			else
				Result := Precursor (eiffel_name)
			end
		end

feature {NONE} -- Constants

	Default_case: NATURAL_8
		once
			Result := {EL_CASE}.Proper
		end

	Etag: STRING = "ETag"

	Uppercase_exception_set_list: STRING = "http2, id, im, md5, te, p3p, www"

end