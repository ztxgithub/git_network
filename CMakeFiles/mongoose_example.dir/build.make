# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.6

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/jame/clion-2016.3/bin/cmake/bin/cmake

# The command to remove a file.
RM = /home/jame/clion-2016.3/bin/cmake/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/jame/share_user/git_network

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/jame/share_user/git_network

# Include any dependencies generated for this target.
include CMakeFiles/mongoose_example.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/mongoose_example.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/mongoose_example.dir/flags.make

CMakeFiles/mongoose_example.dir/main.cpp.o: CMakeFiles/mongoose_example.dir/flags.make
CMakeFiles/mongoose_example.dir/main.cpp.o: main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_network/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/mongoose_example.dir/main.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/mongoose_example.dir/main.cpp.o -c /home/jame/share_user/git_network/main.cpp

CMakeFiles/mongoose_example.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/mongoose_example.dir/main.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jame/share_user/git_network/main.cpp > CMakeFiles/mongoose_example.dir/main.cpp.i

CMakeFiles/mongoose_example.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/mongoose_example.dir/main.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jame/share_user/git_network/main.cpp -o CMakeFiles/mongoose_example.dir/main.cpp.s

CMakeFiles/mongoose_example.dir/main.cpp.o.requires:

.PHONY : CMakeFiles/mongoose_example.dir/main.cpp.o.requires

CMakeFiles/mongoose_example.dir/main.cpp.o.provides: CMakeFiles/mongoose_example.dir/main.cpp.o.requires
	$(MAKE) -f CMakeFiles/mongoose_example.dir/build.make CMakeFiles/mongoose_example.dir/main.cpp.o.provides.build
.PHONY : CMakeFiles/mongoose_example.dir/main.cpp.o.provides

CMakeFiles/mongoose_example.dir/main.cpp.o.provides.build: CMakeFiles/mongoose_example.dir/main.cpp.o


CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o: CMakeFiles/mongoose_example.dir/flags.make
CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o: easylogger/elog_utils.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_network/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o   -c /home/jame/share_user/git_network/easylogger/elog_utils.c

CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/jame/share_user/git_network/easylogger/elog_utils.c > CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.i

CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/jame/share_user/git_network/easylogger/elog_utils.c -o CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.s

CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o.requires:

.PHONY : CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o.requires

CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o.provides: CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o.requires
	$(MAKE) -f CMakeFiles/mongoose_example.dir/build.make CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o.provides.build
.PHONY : CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o.provides

CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o.provides.build: CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o


CMakeFiles/mongoose_example.dir/easylogger/elog.c.o: CMakeFiles/mongoose_example.dir/flags.make
CMakeFiles/mongoose_example.dir/easylogger/elog.c.o: easylogger/elog.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_network/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object CMakeFiles/mongoose_example.dir/easylogger/elog.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/mongoose_example.dir/easylogger/elog.c.o   -c /home/jame/share_user/git_network/easylogger/elog.c

CMakeFiles/mongoose_example.dir/easylogger/elog.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/mongoose_example.dir/easylogger/elog.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/jame/share_user/git_network/easylogger/elog.c > CMakeFiles/mongoose_example.dir/easylogger/elog.c.i

CMakeFiles/mongoose_example.dir/easylogger/elog.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/mongoose_example.dir/easylogger/elog.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/jame/share_user/git_network/easylogger/elog.c -o CMakeFiles/mongoose_example.dir/easylogger/elog.c.s

CMakeFiles/mongoose_example.dir/easylogger/elog.c.o.requires:

.PHONY : CMakeFiles/mongoose_example.dir/easylogger/elog.c.o.requires

CMakeFiles/mongoose_example.dir/easylogger/elog.c.o.provides: CMakeFiles/mongoose_example.dir/easylogger/elog.c.o.requires
	$(MAKE) -f CMakeFiles/mongoose_example.dir/build.make CMakeFiles/mongoose_example.dir/easylogger/elog.c.o.provides.build
.PHONY : CMakeFiles/mongoose_example.dir/easylogger/elog.c.o.provides

CMakeFiles/mongoose_example.dir/easylogger/elog.c.o.provides.build: CMakeFiles/mongoose_example.dir/easylogger/elog.c.o


CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o: CMakeFiles/mongoose_example.dir/flags.make
CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o: easylogger/log.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_network/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o -c /home/jame/share_user/git_network/easylogger/log.cpp

CMakeFiles/mongoose_example.dir/easylogger/log.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/mongoose_example.dir/easylogger/log.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jame/share_user/git_network/easylogger/log.cpp > CMakeFiles/mongoose_example.dir/easylogger/log.cpp.i

CMakeFiles/mongoose_example.dir/easylogger/log.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/mongoose_example.dir/easylogger/log.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jame/share_user/git_network/easylogger/log.cpp -o CMakeFiles/mongoose_example.dir/easylogger/log.cpp.s

CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o.requires:

.PHONY : CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o.requires

CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o.provides: CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o.requires
	$(MAKE) -f CMakeFiles/mongoose_example.dir/build.make CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o.provides.build
.PHONY : CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o.provides

CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o.provides.build: CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o


CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o: CMakeFiles/mongoose_example.dir/flags.make
CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o: easylogger/elog_port.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_network/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building C object CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o   -c /home/jame/share_user/git_network/easylogger/elog_port.c

CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/jame/share_user/git_network/easylogger/elog_port.c > CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.i

CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/jame/share_user/git_network/easylogger/elog_port.c -o CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.s

CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o.requires:

.PHONY : CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o.requires

CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o.provides: CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o.requires
	$(MAKE) -f CMakeFiles/mongoose_example.dir/build.make CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o.provides.build
.PHONY : CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o.provides

CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o.provides.build: CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o


CMakeFiles/mongoose_example.dir/src/mongoose.c.o: CMakeFiles/mongoose_example.dir/flags.make
CMakeFiles/mongoose_example.dir/src/mongoose.c.o: src/mongoose.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_network/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building C object CMakeFiles/mongoose_example.dir/src/mongoose.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/mongoose_example.dir/src/mongoose.c.o   -c /home/jame/share_user/git_network/src/mongoose.c

CMakeFiles/mongoose_example.dir/src/mongoose.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/mongoose_example.dir/src/mongoose.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/jame/share_user/git_network/src/mongoose.c > CMakeFiles/mongoose_example.dir/src/mongoose.c.i

CMakeFiles/mongoose_example.dir/src/mongoose.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/mongoose_example.dir/src/mongoose.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/jame/share_user/git_network/src/mongoose.c -o CMakeFiles/mongoose_example.dir/src/mongoose.c.s

CMakeFiles/mongoose_example.dir/src/mongoose.c.o.requires:

.PHONY : CMakeFiles/mongoose_example.dir/src/mongoose.c.o.requires

CMakeFiles/mongoose_example.dir/src/mongoose.c.o.provides: CMakeFiles/mongoose_example.dir/src/mongoose.c.o.requires
	$(MAKE) -f CMakeFiles/mongoose_example.dir/build.make CMakeFiles/mongoose_example.dir/src/mongoose.c.o.provides.build
.PHONY : CMakeFiles/mongoose_example.dir/src/mongoose.c.o.provides

CMakeFiles/mongoose_example.dir/src/mongoose.c.o.provides.build: CMakeFiles/mongoose_example.dir/src/mongoose.c.o


CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o: CMakeFiles/mongoose_example.dir/flags.make
CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o: src/mongoose_timer.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_network/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o -c /home/jame/share_user/git_network/src/mongoose_timer.cpp

CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jame/share_user/git_network/src/mongoose_timer.cpp > CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.i

CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jame/share_user/git_network/src/mongoose_timer.cpp -o CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.s

CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o.requires:

.PHONY : CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o.requires

CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o.provides: CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o.requires
	$(MAKE) -f CMakeFiles/mongoose_example.dir/build.make CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o.provides.build
.PHONY : CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o.provides

CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o.provides.build: CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o


# Object files for target mongoose_example
mongoose_example_OBJECTS = \
"CMakeFiles/mongoose_example.dir/main.cpp.o" \
"CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o" \
"CMakeFiles/mongoose_example.dir/easylogger/elog.c.o" \
"CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o" \
"CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o" \
"CMakeFiles/mongoose_example.dir/src/mongoose.c.o" \
"CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o"

# External object files for target mongoose_example
mongoose_example_EXTERNAL_OBJECTS =

mongoose_example: CMakeFiles/mongoose_example.dir/main.cpp.o
mongoose_example: CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o
mongoose_example: CMakeFiles/mongoose_example.dir/easylogger/elog.c.o
mongoose_example: CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o
mongoose_example: CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o
mongoose_example: CMakeFiles/mongoose_example.dir/src/mongoose.c.o
mongoose_example: CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o
mongoose_example: CMakeFiles/mongoose_example.dir/build.make
mongoose_example: CMakeFiles/mongoose_example.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/jame/share_user/git_network/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Linking CXX executable mongoose_example"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/mongoose_example.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/mongoose_example.dir/build: mongoose_example

.PHONY : CMakeFiles/mongoose_example.dir/build

CMakeFiles/mongoose_example.dir/requires: CMakeFiles/mongoose_example.dir/main.cpp.o.requires
CMakeFiles/mongoose_example.dir/requires: CMakeFiles/mongoose_example.dir/easylogger/elog_utils.c.o.requires
CMakeFiles/mongoose_example.dir/requires: CMakeFiles/mongoose_example.dir/easylogger/elog.c.o.requires
CMakeFiles/mongoose_example.dir/requires: CMakeFiles/mongoose_example.dir/easylogger/log.cpp.o.requires
CMakeFiles/mongoose_example.dir/requires: CMakeFiles/mongoose_example.dir/easylogger/elog_port.c.o.requires
CMakeFiles/mongoose_example.dir/requires: CMakeFiles/mongoose_example.dir/src/mongoose.c.o.requires
CMakeFiles/mongoose_example.dir/requires: CMakeFiles/mongoose_example.dir/src/mongoose_timer.cpp.o.requires

.PHONY : CMakeFiles/mongoose_example.dir/requires

CMakeFiles/mongoose_example.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/mongoose_example.dir/cmake_clean.cmake
.PHONY : CMakeFiles/mongoose_example.dir/clean

CMakeFiles/mongoose_example.dir/depend:
	cd /home/jame/share_user/git_network && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/jame/share_user/git_network /home/jame/share_user/git_network /home/jame/share_user/git_network /home/jame/share_user/git_network /home/jame/share_user/git_network/CMakeFiles/mongoose_example.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/mongoose_example.dir/depend

