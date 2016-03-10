note
	description: "[
		REPLACE in C source gsl__config.h:
		
			/* Define if you have the isnan function.  */
			#if defined(linux) || defined (macintosh) || defined (_WIN32)
			  #define HAVE_ISNAN 1
			#else
			  #undef HAVE_ISNAN
			#endif
	
		WITH:
			/* Define if you have the isnan function.  */
			#if defined (_MSC_VER) // MS Visual C++
			  #undef HAVE_ISNAN
			#elif defined(linux) || defined (macintosh) || defined (_WIN32)
			  #define HAVE_ISNAN 1
			#else
			  #undef HAVE_ISNAN
			#endif
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	FILE_GSL_CONFIG_H_GCC_TO_MSVC_CONVERTER

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
			Result.extend (platform_macro_condition_for_have_isnan)
		end

	platform_macro_condition_for_have_isnan: EL_MATCH_ALL_IN_LIST_TP
			-- Eg. to match:

			--	#if defined(linux) || defined (macintosh) || defined (_WIN32)
			--	  #define HAVE_ISNAN
		do
			Result := all_of (<<
				string_literal ("#if") |to| agent on_if,
				repeat_pattern_1_until_pattern_2 (
					-- Pattern 1
					one_of (<<
						c_identifier,
						one_character_from ("|()"),
						white_space_character
					>>),

					-- Pattern 1
					string_literal ("#define HAVE_ISNAN")
				) |to| agent on_unmatched_text
			>>)
		end

feature {NONE} -- Match actions

	on_if (text: EL_STRING_VIEW)
			--
		do
			put_string ("#if defined (_MSC_VER) // MS Visual C++")
			put_new_line
			put_string ("%T#undef HAVE_ISNAN")
			put_new_line
			put_string ("#elif")

		end

end
