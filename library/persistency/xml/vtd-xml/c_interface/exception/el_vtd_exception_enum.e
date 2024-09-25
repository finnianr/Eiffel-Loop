note
	description: "Exception type codes from `<vtd_enumerations.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 13:20:47 GMT (Monday 23rd September 2024)"
	revision: "6"

class
	EL_VTD_EXCEPTION_ENUM

feature -- Access

	table: EL_HASH_TABLE [STRING, INTEGER]
		do
			Result := <<
				[out_of_mem, "out of memory"],
				[invalid_argument, "invalid argument"],
				[array_out_of_bound, "array index out of bound"],
				[parse_exception, "parsing"],
				[nav_exception, "vtdNav.c"],
				[pilot_exception, "autoPilot.c"],
				[number_format_exception, "vtdNav.c number format"],
				[xpath_parse_exception, "XPATH parsing"],
				[xpath_eval_exception, "XPATH evaluation"],
				[modify_exception, "XMLModifier.c"],
				[index_write_exception, "indexHandler.c write"],
				[index_read_exception, "indexHandler.c read"],
				[io_exception, "input/output"],
				[transcode_exception, "transcoder.c"],
				[other_exception, "other"]
			>>
		end

feature {NONE} -- Type codes

	array_out_of_bound: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return array_out_of_bound"
		end

	index_read_exception: INTEGER
				--
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return index_read_exception"
		end

	index_write_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return index_write_exception"
		end

	invalid_argument: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return invalid_argument"
		end

	io_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return io_exception"
		end

	modify_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return modify_exception"
		end

	nav_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return nav_exception"
		end

	number_format_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return number_format_exception"
		end

	other_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return other_exception"
		end

	out_of_mem: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return out_of_mem"
		end

	parse_exception: INTEGER
				--
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return parse_exception"
		end

	pilot_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return pilot_exception"
		end

	transcode_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return transcode_exception"
		end

	xpath_eval_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return xpath_eval_exception"
		end

	xpath_parse_exception: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return xpath_parse_exception"
		end

end