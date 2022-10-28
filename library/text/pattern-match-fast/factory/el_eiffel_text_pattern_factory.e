note
	description: "Eiffel language text pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-28 17:32:37 GMT (Friday 28th October 2022)"
	revision: "1"

deferred class
	EL_EIFFEL_TEXT_PATTERN_FACTORY

inherit
	EL_TEXT_PATTERN_FACTORY

feature {NONE} -- Numeric constants

	integer_constant: like all_of
			--
		do
			Result := all_of (<<
				optional (character_literal ('-')),
				one_or_more (digit)
			>>)
		end

	numeric_constant: like all_of
		do
			Result := all_of (<<
				integer_constant,
				optional (all_of (<< character_literal ('.'), integer_constant >>))
			>>)
		end

end

