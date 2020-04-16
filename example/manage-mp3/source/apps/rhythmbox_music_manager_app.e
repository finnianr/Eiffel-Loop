note
	description: "[
		MP3 manager for the Rhythmbox media player. The manager executes tasks defined by task configuration
		written in [https://room.eiffel.com/node/527 Pyxis format] (an XML analog).
	 		See 
		[https://github.com/finnianr/Eiffel-Loop/tree/master/example/manage-mp3/doc/tasks example/manage-mp3/doc/tasks]
		for configuration examples.
		
		See the class hierarchy with [$source RBOX_MANAGEMENT_TASK] as it's root.
		
		Usage:
			el_rhythmbox -manager -config <task-configuration>
			
		The `-manager' switch is needed to select a sub application from the main application.
		See class `APPLICATION_ROOT'.
	]"
	warning: "[
		Use this application at your own risk and note the following points:
		
		* It directly changes the contents of the Rhythmbox song database and edits the ID3 tags in MP3 files.
		* To facilitate syncing it will over-write the MusicBrainz track id with a unique audio signature.
		* It assumes your entire collection is in MP3 format. It won't work with other song formats.
		
		The developer does not assume any responsibility for loss of music data or a corrupted Rhythmbox database.
	]"
	instructions: "See end of page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-16 11:48:29 GMT (Thursday 16th April 2020)"
	revision: "22"

class
	RHYTHMBOX_MUSIC_MANAGER_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [RBOX_MUSIC_MANAGER]
		rename
			Application_option as Sub_application_option
		redefine
			Option_name, Visible_types
		end

	RHYTHMBOX_CONSTANTS

	EL_INSTALLABLE_SUB_APPLICATION
		redefine
			is_main
		end

	SHARED_APPLICATION_OPTION

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("config", "Task configuration file",  << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH})
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				
				[{RBOX_MUSIC_MANAGER}, All_routines],
				[{RBOX_DATABASE}, All_routines],

				[{STORAGE_DEVICE}, All_routines],
				[{NOKIA_PHONE_DEVICE}, All_routines],
				[{SAMSUNG_TABLET_DEVICE}, All_routines],

				[{ADD_ALBUM_ART_TASK}, All_routines],
				[{COLLATE_SONGS_TASK}, All_routines],
				[{DELETE_COMMENTS_TASK}, All_routines],
				[{DISPLAY_INCOMPLETE_ID3_INFO_TASK}, All_routines],
				[{DISPLAY_MUSIC_BRAINZ_INFO_TASK}, All_routines],
				[{EXPORT_MUSIC_TO_DEVICE_TASK}, All_routines],
				[{NORMALIZE_COMMENTS_TASK}, All_routines],
				[{PRINT_COMMENTS_TASK}, All_routines],
				[{PUBLISH_DJ_EVENTS_TASK}, All_routines],
				[{REMOVE_ALL_UFIDS_TASK}, All_routines]
			>>
		end

	visible_types: TUPLE [EL_BUILDER_OBJECT_FACTORY [RBOX_MANAGEMENT_TASK], M3U_PLAYLIST_READER]
		do
			create Result
		end

feature {NONE} -- Installer constants

	Desktop: EL_MENU_DESKTOP_ENVIRONMENT_I
		once
			create {EL_MENU_DESKTOP_ENVIRONMENT_IMP} Result.make (Current)
			Result.enable_desktop_launcher
			Result.set_command_line_options (Application_option.Options_list)
		end

	Desktop_launcher: EL_DESKTOP_MENU_ITEM
		once
			Result := new_launcher (Launcher_relative_icon_path)
		end

	Desktop_menu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
			--
		once
			Result := << new_category ("Sound & Video") >>
		end

	Launcher_relative_icon_path: EL_FILE_PATH
			--
		once
			Result := "MP3-manager.png"
		end

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Manage Rhythmbox Music Collection"
		end

	Option_name: STRING
		once
			Result := "manager"
		end

	is_main: BOOLEAN = True
			-- Is this the master sub application in the whole set
			-- In Windows this will be the app listed in the Control Panel/Programs List

note
	instructions: "[
		The MP3 manager is designed to work in conjunction with GNOME compatible desktop launchers and the GNOME terminal.
		Manager tasks are defined by task configuration files. Dragging a task configuration file onto the launcher executes the task.
		When it is finished it waits for user input. You can either type `quit' and `<enter>' to quit, or else you can use the file
		manager to drag and drop another task file onto the terminal window and hit `<enter>'. This new task is then executed and so on.

		**INSTALLATION**

		Download the executable `el_rhythmbox'
		from [https://github.com/finnianr/Eiffel-Loop/releases/latest https://github.com/finnianr/Eiffel-Loop/releases/latest]
		Strip off the version number by renaming the file and then copy it into `/usr/local/bin' directory. Or alternatively
		you can create a symbolic link to the versioned file name using the following commands:
			cd /usr/local/bin
			sudo ln -f -s el_rhythmbox-<VERSION> el_rhythmbox
		
		`<VERSION>' represents the version number.

		Make sure the following command line tools are installed on your system: `avconv, lame, gvfs-mount, sox, swgen'.

		Now create a desktop launcher by right clicking on your desktop. Edit the desktop launcher using gedit to the following:

			[Desktop Entry]
			Comment=Manage Rhythmbox MP3 collection
			Terminal=false
			Name=Music Collection
			Exec=gnome-terminal --command="el_rhythmbox -manager -logging -config %f" --geometry 140x50+100+100 --title="Rhythmbox Music"
			Type=Application
			Icon=/usr/share/icons/hicolor/256x256/apps/rhythmbox.png

		**Silent tracks**
		
		To use a particular playlist publishing feature you need to create 3 silent MP3 tracks of 1, 2 and 3
		second durations and add them to your music collection. You can use the `swgen' and `lame' command line
		tools to do this. It is important to set the genre name for each to be `Silence'.

		**CLOSE RHYTHMBOX**
		
		It is necessary to close the Rhythmbox media player while using this application because they share
		the same database. An error message will be presented if you try to run a task with the player still open.

		**TESTED PLATFORMS**
		
		This application has been mainly tested on Linux Mint 17 using Rhythmbox ver. 3.0.2. Mint 17 uses the same source
		repositories as Ubuntu 14.04.

		**FILE PATH INPUT**

		If a task prompts you for a song file path, you can drag and drop a file using the ''nautilus'' file manager on to the
		GNOME terminal window. Then hit `<enter>'. You can also use this method to execute a new task after the current one has
		finished by dragging a task configuration file.

		**DEVICE SYNCING**

		To faciliate syncing with external devices, this application over-writes the MusicBrainz track id
		with a unique audio signature.

		**TASK LIST**

		Define the tasks you wish to perform on your collection. Use the examples provided in
		[https://github.com/finnianr/Eiffel-Loop/tree/master/example/manage-mp3/doc/tasks manage-mp3/doc/tasks]
		to help you understand how they work. Note that the tabbed indentation is very important when editing these
		files. Just like in Python programming, if the indentation is not exactly correct the file will not parse
		correctly.

		Note that in the examples shown below the document declaration lines have been omitted for clarity.
			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

		`**task = add_album_art**'

		Automatically adds album art to MP3 files which do not have any album art. The album art is supplied
		from an album art directory containing two folders name 'Artist' and 'Album'. To add new album art,
		find a picture of the artist or album cover on the web. Edit the image to be exactly square shaped
		and save it one of these directories in jpeg format.

		This task will scan the collections for songs having an artist or album name that matches a jpeg name.
		Songs that already have album art will not be touched.

		`**task = collate_songs**'

		Collate songs into a directory structure according to song tags:

			<genre>/<artist-name>/<song-title>.<unique id>.mp3

		`**task = import_videos**'

		Import videos in various formats as MP3 files automatically adding ID3 tags according to folder location.
		Recognized extensions are: flv, m4a, m4v, mp4, mov. Includes facility for mapping video segments to individual
		MP3 files.

		Place videos in your Music folder using the folder naming convention `Music/<genre>/<artist>'.
		The location of the video will be used to fill in ID3 tag info for genre and artist.
		When prompted for information	hit `<enter>' for the default. The default artist is the parent directory.

		This task is able to split a video into several songs by prompting you to input an onset and offset time.
		Enter times using the format mm:ss[.xxx]. Hitting enter without entering anything uses a default value.
		The default ''onset'' is the beginning of the video. The default ''offset'' is the end of the video.

		If recording year is unknown, enter 0. If you have already entered an album name for the same video you
		can enter `"' (for ditto) to use the last one.

		`**task = replace_songs**'

		Use this task to remove a duplicate song from your collection without affecting your playlists.
		You will be prompted to drag and drop a song you wish to remove and then for a song to replace it
		with in your playlists. Songs will also be replaced in all DJ event playlists found in folder
		`$HOME/Music/Playlists'

		`**task = print_comments**'

		Display all ID3 tag comments

		`**task = replace_cortina_set**'

		This task is intended for use by tango DJs to create a set of
		[https://en.wikipedia.org/wiki/Cortina_(tango) tango cortinas] to act as breaks between
		tandas (a set of dance songs).

		During operation you will be prompted to drag and drop a song to use for the cortina.
		The entire song will be divided up into fixed length cortinas with a fade-in and fade-out and
		placed in the directory:
			$HOME/Music/Cortina

		The cortina titles will be named so they can be use to indicate the genre of the tanda following.
		The artist and album information will be added to the cortinas. Note that you can only ever have
		one Cortina set. If you run the operation a second time, the previous cortina set is replaced with
		a new one.

		The frequency of genre titles assumes you wish to construct tandas using the Buenos Aires format
		of genre alternation. A leading letter serves to make all titles unique. The titles are padded with
		underscore characters to make the cortinas clearly visible in playlists.

		For example:
			A. TANGO tanda_________
			B. TANGO tanda_________
			A. MILONGA tanda_______
			C. TANGO tanda_________
			D. TANGO tanda_________
			A. VALS tanda__________

		A typical task configuration will look like this:
			music-collection:
				task = replace_cortina_set; is_dry_run = False

				cortina-set:
					fade_in = 2.0; fade_out = 3.0; clip_duration = 30
					tanda:
						tango_count = 20; tangos_per_vals = 4
						
		Note that `tango_count' must be evenly divisible by `tangos_per_vals'. The number `tango_count / tangos_per_vals'
		is the number of Vals and Milonga cortinas that will be generated. There will also be an extra set of cortinas
		titled: `<X>. OTHER tanda' that can be used to precede a tanda of songs that does not belong to any of the traditional
		tango genres.

		`**task = delete_comments**'

		Delete all ID3 tag comments except for the Rhythmbox 'c0' comment. (Gets rid of iTune identifiers etc.)

		`**task = remove_all_ufids**'

		Remove all UFID fields from ID3 tags

		`**task = update_DJ_playlists**'

		Save all playlists in Pyxis format in the `$HOME/Music/Playlists' directory adding some
		DJ event information: title, venue and DJ name. This extra information is used for the task
		''publish_dj_events''. These playlists also function as a playlist archive. If you delete
		the playlist from Rhythmbox, a copy will still exist in the Playlists folder.

		A typical DJ event playlist will look like this when you have finished editing it.

			﻿pyxis-doc:
				version = 1.0; encoding = "UTF-8"
			DJ-event:
				title = "DATS Milonga Playlist"; date = "4/10/2011"; start_time = "21:35"
				venue = "The Belvedere Hotel"; DJ_name = "Finnian Reilly"; ignore = false
					playlist:
						path:
							"Cortina/John Wilfahrt/A. TANGO tanda _______________.mp3"
							"Tango/Adolfo Carabelli/Cuatro Palábras.01.mp3"
							"Tango/Adolfo Carabelli/Felicia.02.mp3"
							..

		`**task = publish_dj_events**'

		Publish all DJ event playlists saved with the ''update_dj_events'' task to a website using a
		[./library/text/template/evolicity/class-index.html Evolicity] HTML template.

		The event playlists can be edited to change the title, venue, DJ name and milonga start time.
		Any songs that were not played during the milonga can be ommitted from publication by placing
		an 'X' at the beginning of the path name. The milonga participents can look up a song from the
		time that they heard it played.

		See [https://github.com/finnianr/Eiffel-Loop/tree/master/projects.data/rhythmdb/www here] for a template
		example.

		A typical task configuration will look like this:
			music-collection:
				task = publish_dj_events; is_dry_run = False
				DJ-events:
					publish:
						html_template = "playlist.html.evol"; html_index_template = "playlist-index.html.evol"
						www_dir = "$HOME/dev/web-sites/eiffel-loop.com/dancing-DJ"; upload = True
						ftp:
							url = "eiffel-loop.com"; user_home = "/public/www"; destination_dir = "dancing-DJ"

		And here are some playlists published using this configuration:
		[http://www.eiffel-loop.com/dancing-DJ http://www.eiffel-loop.com/dancing-DJ]

		`**task = normalize_comments**'

		Rename ID3 tag comment description 'Comment' as 'c0'. This is an antidote to a bug in Rhythmbox version 2.97
		where editions to 'c0' command are saved as 'Comment' and are no longer visible on reload.

		`**task = archive_songs**'

		Archive songs placed in a special playlist "Archive" by moving them into an archive music folder and removing
		them from Rhythmbox.

		A typical task configuration will look like this:
			music-collection:
				task = archive_songs; is_dry_run = False

				archive-dir:
					"$HOME/Music Extra"

		`**task = display_incomplete_id3_info**'

		Display songs with incomplete [http://id3.org/id3v2.3.0#Declared_ID3v2_frames TXXX ID3] tags (User defined text).

		`**task = update_comments_with_album_artists**'

		Replace 'c0' comment with album-artist info

		`**task = export_music_to_device**'

		Synchronize all (or selected genres) of music with connected device. For older devices that
		are unable to recognize ID3 version 2.4 tags, you can export songs as version 2.3 using the
		'id3_version' attribute.

		A typical task configuration will look like this:
			music-collection:
				task = export_music_to_device; is_dry_run = False

				volume:
					name = "NOKIA-300"; destination = "Music"; id3_version = 2.3
					type = "Nokia phone"
				playlist:
					root = "E:"; subdirectory_name = "playlists"

				selected-genres:
					"Cortina"
					"Foxtrot"
					"Milonga"
					"Tango"
					"Vals"

		`**task = export_playlists_to_device**'

		Export all playlists and associated MP3 to external device. For older devices that
		are unable to recognize ID3 version 2.4 tags, you can export songs as version 2.3 using the
		'id3_version' attribute.

		A typical task configuration will look like this:
			music-collection:
				task = export_playlists_to_device; is_dry_run = False

				volume:
					name = "NOKIA-300"; destination = "Music"; id3_version = 2.3
					type = "Nokia phone"
				playlist:
					root = "E:"; subdirectory_name = "playlists"

		If there is insufficient pause at the end of the song, there is a trick you can use to automatically
		play a short silent track immediately after the song to compensate. This is done by setting the
		beats-per-minute field to the number of extra seconds of silent pause you would like to have at the end of
		the song. This must be a whole number between 1 and 3. You can easily set this in Rhythmbox by opening the
		song properties. For this feature to work you will need to have installed some silent intervals in your
		collection. See ''Silent tracks'' in the installation notes on how to set them up correctly.

		`**task = display_music_brainz_info**'

		Display [https://en.wikipedia.org/wiki/MusicBrainz MusicBrainz info] for any songs that have it.

		`**task = update_comments_with_album_artists**'

		Append field "album-artist" into main 'c0' comment.
	]"

end
