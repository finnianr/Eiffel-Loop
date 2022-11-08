note
	description: "Eiffel language text pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-08 4:37:54 GMT (Tuesday 8th November 2022)"
	revision: "4"

deferred class
	EL_EIFFEL_TEXT_PATTERN_FACTORY

inherit
	EL_TEXT_PATTERN_FACTORY

feature -- Identifiers

	class_name: like c_identifier
			--
		do
			Result := c_identifier_upper
		end

feature -- Type specifier

	class_type: like all_of
		do
			Result := all_of (<<
				class_name,
				optional (all_of (<< optional_white_space, type_list >>)) -- Generic parameter
			>>)
		end

	type_list: like all_of
		do
			Result := all_of (<<
				character_literal ('['),
				optional_white_space,
				recurse (agent class_type, False),
				zero_or_more (
					all_of (<<
						optional_white_space, character_literal (','),
						optional_white_space,
						recurse (agent class_type, False)
					>>)
				),
				character_literal (']')
			>>)
		end

end