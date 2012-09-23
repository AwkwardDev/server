# `config` directory

If configuration files are present in this directory, they will be copied over
to the build tree, which allows to run the server from there. The eligible file
names are listed in `CopyConfig.cmake`. This is useful when using debuggers such
as the one integrated to Visual Studio.

You can find configuration file templates in <build_directory>/config after
running a build. Copy them over, customize them to your liking, then remove
the ".dist" extension.

Additionally, this directory contains the `choose.rb` script to ease switching
between multiple sets of config files. Make a set of config files and give them
a `.<suffix>.conf` extension instead of the usual `.conf`. When you run `ruby
choose.rb <suffix>`, the specified set of files will be copied over the regular
`.conf` files. Be cautious not to overwrite unsaved information!