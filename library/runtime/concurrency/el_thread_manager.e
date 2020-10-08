note
	description: "Thread manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-08 8:56:40 GMT (Thursday 8th October 2020)"
	revision: "7"

class
	EL_THREAD_MANAGER

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_SINGLE_THREAD_ACCESS
		rename
			make_default as make
		redefine
			make
		end

	EL_MODULE_LIO

	EL_SOLITARY
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EL_SOLITARY}
			Precursor {EL_SINGLE_THREAD_ACCESS}
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