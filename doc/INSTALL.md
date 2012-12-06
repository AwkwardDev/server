# Installation Guide

## Supported Operating Systems

We support Linux and Windows (we use Windows 7, but everything will probably
work on XP, Vista and 8 as well). We did not test other Unices than Linux.

Mac OS is unsupported. That's because none of the devs uses a Mac. Also, you can
install Windows or Linux on a Mac.

## Troubleshooting

Post any question, suggestions or remarks you might have on [the
forum](http://project-silverpine.com/forums).

## What you'll need.

For the Linux guys: you can use the package manager supplied by your
distribution to get most of the software listed below.

### Git

On Windows, get either [Github for Windows](http://windows.github.com/) if you
want a GUI interface or [msys-git](http://dev.mysql.com/downloads/mysql/) if you
want only the command line interface. Note that you can have the command line
interface with Github for Windows too, just launch the shortcut named "Git
Shell" (or fiddle with your `PATH` environment variable).

### A MySQL Server

MySQL is a database system. You can get a free MySQL server
[here](http://dev.mysql.com/downloads/mysql/). I recommend to install this only
when you reach the section called [Setting Up The
Database](#installing_the_database_server) as it deals directly with the
post-install configuration step.

### An SQL Frontend

An SQL frontend is a piece of software that can connect to the database in order
to display/modify its data. It can also run queries to retrieve/modify bits of
data that match specific conditions.

I recommend using the official [MySQL
workbench](http://www.mysql.com/downloads/workbench/). Install this after having
installed the SQL server.

Installation on Windows is straightforward. On Linux, packages are supplied for
some popular distributions. Note that you might have success using those package
with other distributions that use the same package system. Also note that you
might have to resolve the dependencies for the package. For instance to install
on Debian I ran the following commands and selected the aptitude resolution that
installs the missing dependencies.

    sudo dpkg -i mysql-workbench-gpl-5.2.43-1ubu1004-i386.deb
    sudo aptitude -f install

If that doesn't work out for you, then you'll have to build from sources.

Of course everything those tools do can be achieved on the command line with the
`mysql` command.

### CMake

CMake is a build configuration tool. It will generate files that our build
system of choice can then use to compile the server. [Get it
here](http://www.cmake.org/cmake/resources/software.html) (take the binary
distribution, unless you know what you are doing). Add CMake to the system path
(this is an installer option).

### A C++ Compiler + Build System

On Windows, this would be [Visual C++ 2012 Express for Windows
Desktop](http://www.microsoft.com/visualstudio/eng/products/visual-studio-express-for-windows-desktop#product-express-desktop-details). The
commercial version will also work. This is the latest version as of the 29
September 2012. Do yourself a favour and use this (or a later) version. We won't
be supporting older versions (tough in principle everything should work on the
2010 edition at least). If you don't like the GUI, it is possible to build via
the command line (see below).

On Linux, we compile with the GNU Compiler Collection (gcc) and GNU Make. Other
compilers (like LLVM/Clang) are currently not supported.

### A Unix/Bash Environment

This is needed to run the database import script.

If you use Linux, you already have this :)

On Windows if you use msys-git, you already have an MSYS install. You need to
add `<msys-git_intall_path>\bin` (angle brackets indicate something you need to
replace by a meaningful value for your own setup) to your `PATH` environment
variable. If you don't know how to change an environment variable, just google
it.

Otherwise, you can get it by downloading MinGW/MSYS
[here](http://sourceforge.net/projects/mingw/files/). Don't forget to select
`MSYS Base System` in the `Select Components` screen. You'll need to add
`<mingw_install_path>\msys\1.0\bin` to your path.

### A Note About the Command Line

You will use some of the software you'll install on the command line. In order
for the command line to find an executable, the path to it must be in an
environment variable called `PATH` (aka "the path").

You usually don't have to take care of this on Linux, because the package
managers place the executables in one of the standard `bin` directories. Those
directories are added to the path by default. On Windows, the installers will
generally take care of it. In the rare cases when you need to manually change
environment variables, I will say so explicitly.

If you have a command line open and that the path changes, it isn't
automatically updated in the opened command line. You need to open a new
up-to-date command line. On Windows you do this by invoking the run menu. Do so
by pressing `WIN + R` or by going to `Start Menu > Run...`. Once there type
`cmd` and press enter.

On Linux you almost never need to take care of this, but if you do change the
path manually, you'll probably do so by editing a shell configuration file. Just
source (if this is chinese to you, google it) the file in your shell to bring it
up to date.

## Compiling the Core

We use the term "core" to distinguish the software that actually runs the server
from other peripheral code and data such as the extractors and the database.

### Cloning the Repository

First, you need to clone the git repository of the server. You can do this
either on the command line or using the Github interface.

If you use the command line, go into the directory where you want to put the
source files and run (note the dot at then end):

    git clone https://github.com/ProjectSilverpine/server.git .

If that doesn't work for some reason, you can also try:

    git clone git://github.com/ProjectSilverpine/server.git .

If you want to use Github, you need to have Github for Windows installed. Open
it and go to `tools > options...`. There, change the default storage directory
to your convenience and write it down for further reference. Changing this field
is the only way to control where the source files will end up, since the
application does not prompt you for a location when cloning. Next, go to [the
github page of the project](https://github.com/ProjectSilverpine/server) and
click on "Clone on Windows". This will create a `server` directory in the
default storage directory. The repository will be cloned in it.

### Running CMake

Next you need to create an empty build directory. This directory can be
anywhere, but I suggest you create it inside the directory where you cloned the
git repo (henceforth: the source directory). It is conventional to give it a
name starting by "build". Create the directory now.

You now need to run CMake, either on the command line or with the GUI tool.

If you use the command line, go inside the build directory, then input the
following command:

    cmake <source directory> -DPREFIX=<desired install location>

If you followed my guideline to place the build directory inside the source
directory, `<source directory>` should simply be `..`.

The whole `-DPREFIX=` part can be ommited, in which case the install location will
default to `C:\Program Files\Silverpine` (usually, I think it uses the
`%ProgramFiles%` environement variable internally) on Windows, or
`/etc/local/bin/Silverpine` on Linux.

Also note that this will use the default CMake generator. The generator dictates
the type of build files CMake generates. In some cases, the default generator
might not be what you want. In that case, use the `-G` command line switch
followed by the generator names between double quotes. You can find a list of
available generators
[here](http://www.cmake.org/cmake/help/v2.8.9/cmake.html#section_Generators).

There are other parameters that can be passed to this command to customize the
build. See the [CMake Parameters Reference](#cmake_parameters_reference) section
below for more information. In particular, for Linux you have to add `-DDEBUG`
at the end of the command if you want to build the server in debug mode. This is
not necessary if using Visual C++, because CMake uses a "multi-configuration
generator" for that.

If you use the GUI, fill the `Where is the source code` field with the source
directory and the `Where to build the binaries` field with the build directory.
Press `Configure` and choose the appropriate generator. If you are following
this guide on Windows, that would be `Visual Studio 11`. Keep `Use default
native compilers` checked.

You now have the opportunity to change the installation path (see the stuff
about `-DPREFIX` above) and other parameters listed in the [CMake Parameters
Reference](#cmake_parameters_reference) section. Once you are done, press
`Generate`. You should now see a bunch of files in the build directory. In
particular, you should see `Silverpine.sln` if you are using Visual Studio, and
`Makefile` if you are using Linux.

### Building and Installing

Once this is done, the only thing that is left is to run your build tool to
actually compile the server. If you use Linux, it is simply:

    make
    make install

The first line compiles the server, while the second moves it to the install
location. The server can actually be run from the build directory, see the
[Running The Server From The Build
Directory](#running_the_server_from_the_build_directory) section below.

If you are using Visual C++ and want to use the GUI, simply double click the
`Silverpine.sln` file in the build directory and Visual C++ will run. First,
select the type of build you want (`Release` or `Debug`) in a scrolling menu
near the top of the screen. In the `Solution Explorer` panel, right click either
the solution or the `ALL_BUILD` project and select `Build`. To install (see the
part about `make install` above), right click the `INSTALL` project and select
`Build`.

If you want to ue the command line, type

    cmake --build . --config <Debug or Release>
    cmake --build . --target install --config <Debug or Release>

Those commands are analogous to the `make` and `make install` on Linux. Actually
these commands should also work on Linux, tough the `--config` part isn't
relevant, because that gets chosen when you run CMake for the first time.

## Extracting the VMAPS and DBC files

In order to run our server, we need to extract some files from the game client.

To extract the files, copy from the source directory `contrib/extractor/ad.exe`
and the content of the `contrib/vmap_extract_assembler_bin` directory to your
World of Warcraft 1.12 installation.

There run `ad.exe`. This will extract files into new `dbc` and `maps`
directories. After that, run `makevmaps_SIMPLE.bat`. This will extract files
into new `vmaps` and `Buildings` directories.

`dbc` (standing for DataBaseClient) contains client-side database files
containing data about items, NPC's, environment, world, etc. These data also
happen to be needed server-side. `maps` holds a 3D mesh of the world. `vmaps`
(Vertical MAPS) holds collision data. It's the stuff that prevents you from
walking trough walls.

You can delete the `Buildings` directory (it's a temporary folder created by the
vmaps extractor and used as input by the vmaps assembler). Copy all other
extracted directories to the `bin` directory under the install directory.

## Setting Up The Database

### Installing the Database Server

On Windows, after the MySQL server setup is complete, the MySQL Server Instance
Configuration Wizard will run. Here are the choices you must make.

- Configuration Type: Detailed Configuration
- Server Type: select what seems appropriate
- Database Usage: Multifunctional Database
- InnoDB Tablespace Settings: select the drive and path where you want the InnoDB
data files to be stored. Basically, that's where part of the data stored in your
database will reside, so choose a fast disk that has some free space.
- Approximate Number of Concurrent Connection: select what seems appropriate
- Enable TCP/IP Networking: yes, note the port number, you'll need it later.
- Enable Strict Mode: yes
- Default Character Set: Best Support for Multilingualism (UTF8)
- \[Windows\] Install As Windows Service: yes
- Include Bin Directory in Windows PATH: yes
- Modify Security Settings: choose a root password
- Create An Anonymous Account: no

On Linux, some distro will prompt you for a root password. If this is not the
case set the root password with:

    sudo mysqladmin -u root -h localhost password <password>

If you want to change an existing password, add the `-p` option:

    sudo mysqladmin -u root -p -h localhost password <password>

If you want to be able to query the sql server as root from another machine, you
need to rerun this command by substituting `localhost` by the IP/hostname used
to reach the server from the other machine.

You should also run `mysql_secure_installation`. This will suggest security
improvements that you may choose to apply or not depending on what you want to
do with your server.

### Populating the Databases

First, you need to get a copy of the databases content, which is kept in a git
repository. Clone the database repo like you did the server repo. The location
doesn't matter. If using the GUI, clone from
[here](https://github.com/ProjectSilverpine/database). If using the command
line, type:

    git clone https://github.com/ProjectSilverpine/database.git .

Now, edit the `mysql_info` file. In our setup, `USER` should be `root` and
`PASS` the password you entered during the MySQL configuration step. You can
leave `HOST` as localhost (meaning the database server runs on the machine from
which we'll import the database data).

To populate the database, run the following command from the database directory
(no GUI alternative here):

    bash mysql_import

### Configuring and Updating the Database

The database repository holds a snapshot of the database that is updated once in
a while. Small changes to the current snapshot are kept in the server
repository.

We need to access the database. Do so by launching MySQL Workbench (or your SQL
frontend of choice). Double-click `Local instance MySQL` under `Open Connection
to Start Querying`. On Linux this might not be present, so you need to create it
by clicking `New Connection` item and filling in the dialog.

In the `Object Browser` tab, expand `zp_realm > Tables`, right click on the
`realmlist` item and click on `Select Rows`. This will bring up a panel called
`realmlist 1`. In there, you can edit the name of your server.  This is the name
that will show up in the realm selection window, inside the game.

You can also set the IP address that the server will be accessed by. By default,
it is your local IP address, the IP that identifies you on your Local Area
Network (LAN). If you wish to restrict access to the server to your computer
only, put the value `127.0.0.1` there. If you wish to make your server
accessible from the internet, you need to put your [public IP
address](http://www.ip-adress.com/). On most home computers, this address
changes once in a while (e.g. every day) so you might wish to setup a domain
name to redirect to your current IP address. This can be done via providers such
as [no-ip](http://www.no-ip.com/personal/).

Next bring up the `zp_world > db_version` table (same process as before). Look
at the name of the third column. Note the number that is prefixed with the `z`
character. Then, go to the `sql/updates` directory inside the server
repository. In the MySQL workbench, open each file (folder icon) that has a
bigger number than the one you noted. For each file, look at the word that
follows the third underscore in its name. It should be something like `mangos`
or `characters`. It indicates to which database you must apply the
patch. `mangos` means the world database; the others are pretty obvious. Apply
patches in increasing number order. Apply a patch by double-clicking on the
database you wish to apply it to, then by clicking on the thunder icon.

When updates are made to the database, they'll always come in the form of
patches. So you won't need to use the database repository again.

Note that we are currently displeased with the process for making updates to the
database, so this might change soon.

## Configuring and Running Your Server

### Configuring the Server

We need to edit the configuration files that are in the `etc` directory under
the install directory. Rename (or make a copy of) each file ending in `.dist`
and change the name to remove the `.dist`.

In `mangosd.conf`, you need to edit the three `<database>DatabaseInfo`
fields. Set the ip address and port of the database server. If you run them on
the same machine, the default `127.0.0.1` is fine. The default port is also the
MySQL server default. You need to replace the `mangos;mangos` part by your MySQL
username (`root` assuming you have followed this guide) and password. Finally
change the database names to `zp_realm`, `zp_world` and `zp_characters`. In case
you were wondering, `zp` stands for "Zero Project" and is used for historical
reasons.

If you changed the port in the `realmlist` table of the database, change it also
under the `WorldServerPort` field.

We said earlier to copy the extracted `maps`, `vmaps` and `dbc` directories to
the `bin` directory. This corresponds to the default value of the `DataDir`
field. If you want to put the extracted files elsewhere, just update this field
accordingly.

In `realmd.conf`, change the `LoginDatabaseInfo` field in the same way as the
corresponding field in `mangosd.conf`.

In `scriptdevzero.conf`, change the `ScriptDevZeroDatabaseInfo` field in the
same way as similar fields in the other files. The database name needs to be
replaced by `zp_scripts`.

### Running The Server

To run the server, simply go in the `bin` directory under the install directory
and launch the `realmd` and `mangosd` executables. On Windows, those have a
`.exe` file extension. `realmd` is the login server while `mangosd` is the game
server.

You can interact with `mangosd` trough a command prompt. On Windows the prompt
will pop when you launch the program. On Linux, you'll need to call the program
from the command line to get the prompt or view any output.

To get to the prompt, you might have to press ENTER. Once you are there, you can
create new accounts and set their privilege level. Create a user with `account
create <user> <pass>`. Make the user a Game Master (GM) with `account set
gmlevel <user> 3`. The GM level gives users access to various commands. Check
the [command reference](http://project-silverpine.com/devwiki/index.php?
title=Command_reference) for more info (only the commands marked `112` are
usable!).

### Connecting to the Server

Finally, go to your WoW 1.12 installation and edit the `realmlist.wtf` file to
read `set realmlist <server-ip>`. You should use the same IP address as the one
that is in the `realmlist` table of the `zp_realm` database (this assumes the
login server runs on the same machine as the game server). You can use C-style
line comments (`//`) if you need to switch between multiple servers:

    set realmlist 127.0.0.1 // my home server
    // set realmlist login.otherserver.com // other server

If you did everything right and I didn't screw my guide, you can now connect to
your server. Congratulations!

## CMake Parameters Reference

When invoking CMake (in order to generate build files), you can specify the
values of some variables. On the command line, you do this by appending
`-D<variable>=<value>` (note the absence of spaces) at the end of your
command. For instance:

    cmake .. -DDEBUG=TRUE -DPREFIX="C:\Program Files\MyServer\"

On the GUI, the customizable variables will simply show up in the middle of the
window, where you can customize them at will.

Most variables are boolean: either true or false. Unless stated otherwise,
boolean variables default to false.

`DEBUG`
: Compile with debug information and checks. Not need for multi-configuration
CMake generators such as Visual Studio.

`DPREFIX`
: The path where the server should be installed. Absolute or relative to the
source directory.

`USE_STD_MALLOC`
: Use the standard library malloc function instead of the one from Intel
Threading Building Blocks (TBB). I guess this can be useful for debugging or
if on your machine the standard malloc outperforms the TBB one.

`NOPCH`
: Don't use precompiled headers. This will increase build time. I'm not quite
sure in which situation this is useful.

`ACE_USE_EXTERNAL`
: Use an external ACE library instead of the one bundled with the server. Useful
if you run multiple servers on your machine or if some other software is already
using the ACE libraries. This way, you avoid loading the libraries in memory
multiple times.

`TBB_USE_EXTERNAL`
: Same story as ACE_USE_EXTERNAL but for the TBB libraries.

`ACE_ROOT`
: The path were the external ACE library resides. Only meaningful if
`ACE_USE_EXTERNAL` is TRUE. Some default locations will be tried if not
supplied.

`TBB_ROOT`
: The path were the external TBB library resides. Only meaningful if
`TBB_USE_EXTERNAL` is TRUE. Some default locations will be tried if not
supplied.

## Running The Server From The Build Directory

Sometimes it makes sense to run the server from the build directory. In
particular if you want to attach a debugger to the server, some IDEs such as
Visual Studio are quite picky about the location of the executables. It expects
to find them at the place where they were created, so in the build directory
instead of the install directory.

To this effect, the server can be run from the build directory. With a regular
generator (not a multi-configuration one), you'll find the usual `bin` and `etc`
directories under the build directory. With a multi-configuration generator,
things are slightly more complicated. The executables and libraries are placed
in the `bin/<configuration>` directory. This means that the config files will be
in `bin/etc`.

You still need to copy the extracted files, or to modify the `DataDir` field in
`mangosd.conf`.  Changing the config is probably the better idea, as I like to
be able to delete my build directories without aftertoughts.

For the same reason (impunity in nuking the build directory), the config in the
build directory is automatically copied from the `config` directory. To set up a
custom config, start by building the project. Default configuration files will
be generated in `<build_directory>/config`. Copy them over to the `config`
directory, edit them to your liking then drop the `.dist` extension. The next
time you compile, these configuration files will be copied to the proper
location in the build directory in order to be used by the server if run from
the build directory.