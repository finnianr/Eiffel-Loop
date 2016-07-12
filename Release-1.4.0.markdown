# Eiffel-Loop as it was on the 12th July 2016
For this release a major effort has been made to make Eiffel-Loop more modular with fewer inter-dependencies between libraries. In particular, most modules no longer depend on the logging module, but only the class `EL_MODULE_LIO` which is merely an alternative to `io` output.

## STRUCTURAL CHANGES
* Moved all ES overrides into separate directory tree of library
* Separated a cluster from `Eiffel2Java.pecf` into a separate override ECF `ES-eiffel2java.pecf`
* Moved `text/template/evolicity` from `base.pecf` to a new ECF `evolicity.pecf`
* Moved `runtime/process/commands` from `base.pecf` to a new ECF `os-commands.pecf`. Moved any `EL_COMMAND_I` dependencies found in `base` to `runtime/process/commands`.
* Moved logging classes from `base.pecf` to a new ECF `logging.pecf`.
* Moved thread extensions classes from `base.pecf` to a new ECF `logging.pecf`.
* Moved `base.pecf` and it's classes into a separate directory `library/base`.
* Moved all override *ECF* `ES-*.pecf` into sub directory `library/override`.
* Removed dependency on logging classes from most libraries that don't absolutely need it. Output is now through the `lio` object which is just an extension of `io`.
* Moved classes for regression and unit testing from `base` to `testing.ecf` module.

## APP-MANAGEMENT library
* Made it possible to override name of main thread for logged console output in class `EL_SUB_APPLICATION`

## BASE library
* New class `EL_MODULE_LIO` is an alternative to using `io` and provides color highlighting capabilities for the gnome-terminal. `lio` output can be optionally fed into Eiffel-Loop logging if `logging.ecf` is included in your project.
* Added new routines `put_substitution` and `put_labeled_substitution` to  `EL_LOGGABLE` that take advantage of the `EL_ZSTRING` template substitution feature.
* New class `EL_EXCEPTION_ROUTINES` available through `EL_MODULE_EXCEPTION`. Uses templating features of `ZSTRING` for setting exception descriptions.
* Added functions `first_step` `step_count` to `EL_PATH`
* New class `EL_CONSOLE_FILE_PROGRESS` inheriting `EL_FILE_PROGRESS_LISTENER`. Displays progress of a file operation in the terminal console using a progress meter and percentage completion read out.

### Bug fixes in base
* Fixed `{EL_DIR_PATH}.is_parent_of`
* Fixed `{EL_READABLE_ZSTRING}.adapted_general`. Incorrect once buffer was being used.
* Fixed `{EL_UNENCODED_CHARACTERS}.remove`
* Changed internal routine `{EL_READABLE_ZSTRING}.adapted_general` to accept an extra argument `argument_number`. Only if `argument_number = 1` can buffer be used.
* Fixed failing tests in `ZSTRING_TEST_SET` when system codec is set to `EL_ISO_8859_1_ZCODEC`
* Fixed `{EL_ISO_8859_1_ZCODEC}.as_lower`. Incorrect result for code 190.

## EVOLICITY library
* Removed dependency on logging library
* Compilation failure and missing templates now raise exceptions instead of just being logged

## FTP library
* `EL_FTP_WEBSITE` now inherits `EL_FTP_PROTOCOL`
* Moved login routines from `EL_FTP_WEBSITE` to `EL_FTP_PROTOCOL`
* Introduced new class `EL_FTP_SYNC` that performs *rsync* like file synchronization for a list of files under a common root directory.

### Class EL_FTP_PROTOCOL
* Add precondition to `make_directory` that argument `dir_path` is relative path
* `make_directory` can recursively create a deep path.
* Fixed `EL_FTP_PROTOCOL` so all commands are encoded as UTF-8.
* Added routines to `EL_FTP_PROTOCOL` for deleting files and directories
* Changed `files_exists` and `directory_exists` to use the ftp `SIZE` command

## LOGGING library
* Logging classes now have their own ECF: `logging.ecf`
* New deferred class `EL_LOGGABLE` which is now the parent of all loggging classes.
* Moved the `log_or_io` object into the `BASE library` and renamed it as `lio` accessible from `EL_MODULE_LIO`. It can now be used purely as an alternative of the `io` object without any need for the `LOGGING library`.
* Introduced new threading classes which have log output.
* Threads are now made visible in console by overriding routine `{EL_STOPPABLE_THREAD}.on_start` to register thread with log manager available from class `EL_MODULE_LOG_MANAGER`. See class `EL_LOGGED_WORKER_THREAD` for example:
```` eiffel
feature {NONE} -- Event handling
	on_start
		do
			Log_manager.add_thread (Current)
		end
````
* New `EL_LOGGED_EVENT_COUNTER` to monitor thread event production or consumption.

## THREAD libary
* Thread classes now have their own ECF: `thread.ecf`
* Removed dependency on Eiffel-Loop logging.
* Introduced class `EL_NAMED_THREAD` to provide default thread name.
* attribute `is_visible_in_console` is now obsolete. See above.

## VISION-2 EXTENSIONS library
* New `EL_LOGGED_THREAD_MANAGER` to log thread management operations
* New class `EL_SHARED_LOGGED_THREAD_MANAGER` to make thread manager shared from `EL_SHARED_THREAD_MANAGER` an instance of `EL_LOGGED_THREAD_MANAGER`.

## TESTING library
* New class `EL_FILE_DATA_TEST_SET` for generating a tree of test files. See `HELP_PAGES_TEST_SET` for an example.
* Renamed class `EL_TESTING_ROUTINES` to `EL_REGRESSION_TESTING_ROUTINES` available throught `EL_MODULE_TEST`. It overrides Eiffel-Loop logging to obtain a CRC-32 digest from both `lio` and `log` output for regression test procedures.

## OTHER CHANGES
* The root directory script `build_doc.sh` builds the Eiffel-Loop documentation in directory `doc` using the configuration in `doc-config`.

## OTHER FIXES
* Changes [scons](http://www.scons.org/) build to let estudio do automatic building of precompiles. This is to fix a problem were the `precomp.o` object would occasionally disappear.
* Fixed eiffel2java example so that the Velocity jar automatically downloads into contrib directory from [scons](http://www.scons.org/) freeze.
* Minor fixes in eiffel2java example
* Fixed bug in argument parsing for sub-app `class_renamer` in `el_toolkit`
* Fixed bug in graphics example: `QUANTUM_BALL_ANIMATION_APP`

## TOOL el_toolkit
* Added a new sub-application `EIFFEL_REPOSITORY_PUBLISHER_APP` available through the `-publish_repository` option.
