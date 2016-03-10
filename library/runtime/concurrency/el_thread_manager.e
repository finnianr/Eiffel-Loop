note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 13:44:02 GMT (Thursday 1st January 2015)"
	revision: "3"

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
						log_or_io.put_labeled_string ("Waiting to stop thread", name (thread.item))
						log_or_io.put_new_line
						Execution.sleep (Default_stop_wait_time)
						stopped := thread.item.is_stopped
					end
				end
--			end
			end_restriction
		end

	list_active
		do
			restrict_access
--			synchronized
				across threads as thread loop
					if thread.item.is_active then
						log_or_io.put_labeled_string ("Active thread", name (thread.item))
						log_or_io.put_new_line
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

	name (thread: EL_STOPPABLE_THREAD): STRING
		do
			if attached {EL_IDENTIFIED_THREAD} thread as identified_thread then
				Result := identified_thread.log_name
			else
				Result := thread.generator.as_lower
			end
		end

	threads: ARRAYED_LIST [EL_STOPPABLE_THREAD]

feature {NONE} -- Constants

	Default_stop_wait_time: INTEGER
			-- Default time to wait for thread to stop in milliseconds
		once
			Result := 2000
		end

end
