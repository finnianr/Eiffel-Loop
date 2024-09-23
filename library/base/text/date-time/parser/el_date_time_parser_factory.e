note
	description: "Factory for ${EL_DATE_TIME} related parsers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:50:43 GMT (Monday 23rd September 2024)"
	revision: "3"

class
	EL_DATE_TIME_PARSER_FACTORY

inherit
	EL_DATE_OR_TIME_PARSER_FACTORY
		redefine
			new_code_string
		end

	EL_MODULE_DATE_TIME

create
	make

feature {NONE} -- Factory

	new_code_string (format: STRING): EL_DATE_TIME_CODE_STRING
		local
			zone_designator_count: INTEGER
		do
			if attached Conversion_table [format] as converter then
				create {EL_ISO_8601_DATE_TIME_CODE_STRING} Result.make (format, converter)
			else
				zone_designator_count := Date_time.zone_designator_count (format)
				if zone_designator_count > 0 then
					create {EL_ZONED_DATE_TIME_CODE_STRING} Result.make (format, zone_designator_count)
				else
					create Result.make (format)
				end
			end
		end

feature {NONE} -- Constants

	Conversion_table: EL_HASH_TABLE [EL_DATE_TIME_CONVERSION, STRING]
		once
			create Result.make_equal (3)
			Result [Date_time.ISO_8601.format] := create {EL_ISO_8601_DATE_TIME_CONVERSION}.make
			Result [Date_time.ISO_8601.format_extended] := create {EL_ISO_8601_EXTENDED_DATE_TIME_CONVERSION}.make
		end

end