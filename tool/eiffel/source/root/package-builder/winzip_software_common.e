note
	description: "Winzip software common"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-20 16:43:31 GMT (Tuesday 20th October 2020)"
	revision: "2"

deferred class
	WINZIP_SOFTWARE_COMMON

inherit
	EL_MODULE_TUPLE

feature -- Contract Support

	valid_architecture_list	(a_list: STRING): BOOLEAN
		do
			Result := True
			across a_list.split (',') as list until not Result loop
				list.item.left_adjust
				inspect list.item.to_integer
					when 32, 64 then
				else
					Result := False
				end
			end
		end

	valid_target_list	(a_list: STRING): BOOLEAN
		do
			Result := True
			across a_list.split (',') as list until not Result loop
				list.item.left_adjust
				Result := Target_set.has (list.item)
			end
		end

feature {NONE} -- Constants

	Target_set: EL_STRING_8_LIST
		once
			create Result.make_from_tuple (Target)
		end

	Target: TUPLE [exe, installer: STRING]
		once
			create Result
			Tuple.fill (Result, "exe, installer")
		end

end