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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-17 14:16:41 GMT (Monday 17th December 2018)"
	revision: "4"

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

	delimiting_pattern: like one_of
			--
		do
			Result := Precursor
			Result.extend (platform_macro_condition_for_have_isnan)
		end

	platform_macro_condition_for_have_isnan: like all_of
			-- Eg. to match:

			--	#if defined(linux) || defined (macintosh) || defined (_WIN32)
			--	  #define HAVE_ISNAN
		do
			Result := all_of (<<
				string_literal ("#if") |to| agent on_if,
				repeat_p1_until_p2 (
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
