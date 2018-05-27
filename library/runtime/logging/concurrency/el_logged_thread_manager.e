note
	description: "Logged thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_LOGGED_THREAD_MANAGER

inherit
	EL_THREAD_MANAGER
		redefine
			on_wait, list_active
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

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