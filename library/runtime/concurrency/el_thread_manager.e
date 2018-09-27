note
	description: "Thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_THREAD_MANAGER

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT
		redefine
			default_create
		end

	EL_SINGLE_THREAD_ACCESS
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			make_default
			create threads.make (10)
		end

feature -- Access

	active_count: INTEGER
		do
			restrict_access
--			synchronized
				across threads as thread loop
					if thread.item.is_active then
						Result := Result + 1
					end
				end
--			end
			end_restriction
		end

feature -- Basic operations

	list_active
		do
		end

	stop_all
			--
		do
			restrict_access
--			synchronized
				across threads as thread loop
					if not (thread.item.is_stopped or thread.item.is_stopping) then
						thread.item.stop
					end
				end
--			end
			end_restriction
		end

	join_all
		local
			stopped: BOOLEAN
		do
			restrict_access
--			synchronized
				across threads as thread loop
					-- Wait for thread to stop
					from stopped := thread.item.is_stopped until stopped loop
						on_wait (thread.item.name)
						Execution.sleep (Default_stop_wait_time)
						stopped := thread.item.is_stopped
					end
				end
--			end
			end_restriction
		end

feature -- Element change

	remove_all_stopped
			--
		do
			restrict_access
--			synchronized
				from threads.start until threads.after loop
					if threads.item.is_stopped then
						threads.remove
					else
						threads.forth
					end
				end
--			end
			end_restriction
		end

	extend (a_thread: EL_STOPPABLE_THREAD)
		do
			restrict_access
--			synchronized
				threads.extend (a_thread)
--			end
			end_restriction
		end

feature -- Status query

	all_threads_stopped: BOOLEAN
			--
		do
			restrict_access
--			synchronized
				Result := threads.for_all (agent {EL_STOPPABLE_THREAD}.is_stopped)
--			end
			end_restriction
		end

feature {NONE} -- Implementation

	on_wait (thread_name: STRING)
		do
		end

	threads: ARRAYED_LIST [EL_STOPPABLE_THREAD]

feature {NONE} -- Constants

	Default_stop_wait_time: INTEGER
			-- Default time to wait for thread to stop in milliseconds
		once
			Result := 2000
		end

end