note
	description: "Shared table of ${ENCODING} objects by `code_page'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:29:39 GMT (Monday 25th December 2023)"
	revision: "6"

deferred class
	EL_SHARED_ENCODING_TABLE

inherit
	EL_MODULE

	EL_SHARED_ENCODINGS

feature {NONE} -- Implementation

	new_encoding (name: STRING): ENCODING
		do
			if name.starts_with (Prefix_cp)
				and then attached name.substring (Prefix_cp.count + 1, name.count) as code
				and then code.is_natural
			then
				create Result.make (code)
			else
				create Result.make (name)
			end
		end

feature {NONE} -- Constants

	Prefix_cp: STRING = "cp"

	Encoding_table: EL_AGENT_CACHE_TABLE [ENCODING, STRING]
		once
			create Result.make_equal (5, agent new_encoding)
			across Encodings.standard as encoding loop
				Result.extend (encoding.item, encoding.item.code_page)
			end
		end
end