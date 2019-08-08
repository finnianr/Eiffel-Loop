note
	description: "Shared table of [https://en.wikipedia.org/wiki/Singleton_pattern singleton objects]"
	notes: "See end of class"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_SHARED_SINGLETONS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	set_singleton (obj: ANY)
		-- for clarity we supply `Current' as argument `obj'
		do
			Singleton_table.put (obj, {ISE_RUNTIME}.dynamic_type (obj))
		end

feature {NONE} -- Constants

	Singleton_table: HASH_TABLE [ANY, INTEGER]
		-- singleton item
		once ("PROCESS")
			create Result.make (11)
		end

note
	notes: "[
		To shared an object with the rest of an application as a singleton,
		make a call to `set_singleton' as follows:

			class MY_CLASS
			inherit
				EL_SHARED_SINGLETONS

			feature {NONE}	-- Initialization
				make
					do
						set_singleton (Current)
						..
					end

		then define shared once function as follows:

			deferred class SHARED_GLOBAL_INSTANCE
			inherit
				EL_ANY_SHARED

			feature {NONE} -- Constants

				Global_instance: MY_CLASS
					local
						l: EL_SINGLETON [MY_CLASS]
					once ("PROCESS")
						create l
						Result := l.singleton
					end
			end

	]"

end
