note
	description: "[
		Add line in NUM2.c to include gsl__config.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	FILE_NUM2_C_GCC_TO_MSVC_CONVERTER

inherit
	GCC_TO_MSVC_CONVERTER
		redefine
			delimiting_pattern
		end

	EL_C_PATTERN_FACTORY

create
	make

feature {NONE} -- C constructs

	delimiting_pattern: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := Precursor
			Result.extend (include_melder_h_macro)
		end

	include_melder_h_macro: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				start_of_line,
				string_literal ("#include %"melder.h%"") |to| agent on_include_melder_h_macro
			>>)
		end

feature {NONE} -- Match actions

	on_include_melder_h_macro (text: EL_STRING_VIEW)
			--
		do
			put_string (text)
			put_new_line
			put_string ("#include %"gsl__config.h%"")
		end


end
