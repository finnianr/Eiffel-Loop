note
	description: "Shared html class source table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 11:34:11 GMT (Monday 5th August 2019)"
	revision: "5"

deferred class
	SHARED_HTML_CLASS_SOURCE_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	class_name (text: ZSTRING): ZSTRING
		local
			done, alpha_found: BOOLEAN
		do
			if text.item (1).is_alpha then
				Result := text
			else
				create Result.make (text.count - 2)
				across text as c until done loop
					if alpha_found then
						inspect c.item
							when '_', 'A' .. 'Z' then
								Result.append_character (c.item)
						else
							done := True
						end
					elseif c.item.is_alpha then
						alpha_found := True
						Result.append_character (c.item)
					end
				end
			end
		end

	Class_source_table: EL_ZSTRING_HASH_TABLE [EL_FILE_PATH]
		once ("PROCESS")
			create Result.make_equal (100)
		end
end
