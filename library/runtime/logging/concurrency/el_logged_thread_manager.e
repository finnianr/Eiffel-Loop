note
	description: "Logged thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:43:07 GMT (Monday 1st July 2019)"
	revision: "6"

class
	EL_LOGGED_THREAD_MANAGER

inherit
	EL_THREAD_MANAGER
		redefine
			on_wait, list_active
		end

	EL_MODULE_LOG

feature -- Basic operations

	list_active
		do
			restrict_access
--			synchronized
				across threads as thread loop
					if thread.item.is_active then
						lio.put_labeled_string ("Active thread", thread.item.name)
						lio.put_new_line
					end
				end
--			end
			end_restriction
		end

feature {NONE} -- Implementation

	on_wait (thread_name: STRING)
		do
			lio.put_labeled_string ("Waiting to stop thread", thread_name)
			lio.put_new_line
		end
end
