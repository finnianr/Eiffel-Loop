note
	description: "Exception type codes from `<vtd_enumerations.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-21 10:49:00 GMT (Wednesday 21st April 2021)"
	revision: "1"

class
	EL_VTD_EXCEPTION_ENUM

feature -- Access

	description (code: INTEGER): STRING
	 	do
	 		if Description_table.has_key (code) then
		 		Result := Description_table.found_item
		 	else
		 		create Result.make_empty
	 		end
	 	end

feature -- Type codes

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

feature {NONE} -- Constants

	Description_table: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<<
				[out_of_mem, "out of memory"],
				[invalid_argument, "invalid argument"],
				[array_out_of_bound, "array index out of bound"],
				[parse_exception, "parse exception"],
				[nav_exception, "navigation exception"],
				[pilot_exception, "pilot exception"],
				[number_format_exception, "number format exception"],
				[xpath_parse_exception, "xpath parse exception"],
				[xpath_eval_exception, "xpath eval exception"],
				[modify_exception, "modify exception"],
				[index_write_exception, "index write exception"],
				[index_read_exception, "index read exception"],
				[io_exception, "io exception"],
				[transcode_exception, "Invalid UCS char for ASCII format"],
				[other_exception, "other exception"]
			>>)
		end
end