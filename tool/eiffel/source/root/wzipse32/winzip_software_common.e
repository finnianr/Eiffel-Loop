note
	description: "Winzip software common"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-19 15:44:15 GMT (Monday 19th October 2020)"
	revision: "1"

class
	WINZIP_SOFTWARE_COMMON

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

	Target_set: ARRAY [STRING]
		once
			Result := << "exe", "installer" >>
			Result.compare_objects
		end
end