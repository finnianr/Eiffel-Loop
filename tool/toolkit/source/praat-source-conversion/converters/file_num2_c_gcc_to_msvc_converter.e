note
	description: "[
		Add line in NUM2.c to include gsl__config.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:27:26 GMT (Sunday 20th December 2015)"
	revision: "4"

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

	on_include_melder_h_macro (text: EL_STRING_VIEW)
			--
		do
			put_string (text)
			put_new_line
			put_string ("#include %"gsl__config.h%"")
		end


end