note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-03 13:10:59 GMT (Wednesday 3rd August 2016)"
	revision: "2"

class
	GCC_TO_MSVC_CONVERTER

inherit
	EL_FILE_PARSER_TEXT_FILE_CONVERTER
		rename
			make_default as make
		redefine
			edit
		end

create
	make

feature {NONE} -- C constructs

	delimiting_pattern: like one_of
			--
		do
			Result := one_of (<<
				string_literal ("#include <crtl.h>") |to| agent comment_out_line_remainder,
				string_literal ("_Environ") |to| agent on_Environ,

				all_of (<<
					string_literal ("static"),
					white_space,
					string_literal ("inline")

				>>) |to| agent replace (?, "static __inline"),

				all_of (<<
					string_literal ("inline"),
					white_space,
					string_literal ("static")

				>>) |to| agent replace (?, "__inline static")
			>>)
		end

feature -- Match actions

	on_Environ (text: EL_STRING_VIEW)
			--
		do
			put_string ("_environ")
		end

	comment_out_line_remainder (line: EL_STRING_VIEW)
			--
		do
			put_string ("//")
			put_string (line)
		end

feature -- Basic operations

	edit
			--
		do
			put_string ("// DO NOT EDIT. Generated by Eiffel tool: class PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP")
			put_new_line
			put_new_line
			Precursor
		end

end