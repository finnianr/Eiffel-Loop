note
	description: "Object that can broadcast event notifications to one or more listeners"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-22 16:19:01 GMT (Saturday 22nd August 2020)"
	revision: "5"

class
	EL_EVENT_BROADCASTER

create
	make

feature {NONE} -- Initialization

	make
		do
			listener := Default_listener
		end

feature -- Basic operations

	notify
		do
			listener.notify
		end

feature -- Element change

	add_action (action: PROCEDURE)
		do
			add_listener (create {EL_AGENT_EVENT_LISTENER}.make (action))
		end

	add_listener (a_listener: like listener)
		do
			inspect listener.listener_count
				when 0 then
					listener := a_listener
				when 1 then
					create {EL_EVENT_LISTENER_PAIR} listener.make (listener, a_listener)
				when 2 then
					check attached {EL_EVENT_LISTENER_PAIR} listener as pair then
						create {EL_EVENT_LISTENER_LIST} listener.make (<< pair.left, pair.right, a_listener >>)
					end
			else
				check attached {EL_EVENT_LISTENER_LIST} a_listener as list then
					list.extend (a_listener)
				end
			end
		ensure
			incremented: listener.listener_count = old listener.listener_count + 1
			assigned: listener.listener_count = 1 implies listener = a_listener
			right_in_pair: listener.listener_count = 2
									implies attached {EL_EVENT_LISTENER_PAIR} listener as pair and then pair.right = a_listener

			last_in_list: listener.listener_count >= 3
									implies attached {EL_EVENT_LISTENER_LIST} listener as list and then list.last = a_listener
		end

feature {NONE} -- Internal attributes

	listener: EL_EVENT_LISTENER

feature {NONE} -- Constants

	Default_listener: EL_DEFAULT_EVENT_LISTENER
		once ("PROCESS")
			create Result
		end
end
