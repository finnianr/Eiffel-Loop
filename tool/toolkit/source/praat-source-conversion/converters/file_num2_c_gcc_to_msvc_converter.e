note
	description: "[
		Add line in NUM2.c to include gsl__config.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	FILE_NUM2_C_GCC_TO_MSVC_CONVERTER

inherit
	GCC_TO_MSVC_CONVERTER
		redefine
			delimiting_pattern
		end

create
	make

feature {NONE} -- C constructs

	delimiting_pattern: like one_of
			--
		do
			Result := Precursor
			Result.extend (include_melder_h_macro)
		end

	include_melder_h_macro: like all_of
			--
		do
			Result := all_of (<<
				start_of_line,
				string_literal ("#include %"melder.h%"") |to| agent on_include_melder_h_macro
			>>)
		end

feature {NONE} -- Match actions

	on_include_melder_h_macro (start_index, end_index: INTEGER)
			--
		do
			put_string (source_substring (start_index, end_index, False))
			put_new_line
			put_string ("#include %"gsl__config.h%"")
		end


end
