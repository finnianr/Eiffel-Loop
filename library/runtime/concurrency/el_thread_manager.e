note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-30 8:27:14 GMT (Thursday 30th May 2013)"
	revision: "2"

class
	EL_THREAD_MANAGER

inherit
	ANY
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			create threads.make (create {like threads.item}.make (10))
		end

feature -- Access

	active_count: INTEGER
		do
			threads.lock
--			synchronized
				across threads.item as thread loop
					if not thread.item.is_stopped then
						Result := Result + 1
					end
				end
--			end
			threads.unlock
		end

	threads: EL_STD_SYNCHRONIZED_REF [ARRAYED_LIST [EL_STOPPABLE_THREAD]]

feature -- Basic operations

	stop_all
			--
		do
			threads.lock
--			synchronized
				across threads.item as thread loop
					if not (thread.item.is_stopped or thread.item.is_stopping) then
						thread.item.stop
					end
				end
--			end
			threads.unlock
		end

feature -- Element change

	remove_all_stopped
			--
		do
			threads.lock
--			synchronized
				from threads.item.start until threads.item.after loop
					if threads.item.item.is_stopped then
						threads.item.remove
					else
						threads.item.forth
					end
				end
--			end
			threads.unlock
		end

	extend (a_thread: EL_STOPPABLE_THREAD)
		do
			threads.lock
--			synchronized
				threads.item.extend (a_thread)
--			end
			threads.unlock
		end

feature -- Status query

	all_threads_stopped: BOOLEAN
			--
		do
			threads.lock
--			synchronized
				Result := threads.item.for_all (agent {EL_STOPPABLE_THREAD}.is_stopped)
--			end
			threads.unlock
		end

end
