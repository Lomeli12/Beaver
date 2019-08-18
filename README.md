# Beaver

Beaver is a build system for Vala, written in Vala. It's goal is to be dead simple and quick to setup.

## Why?

Because I wanted to learn how to use Vala and the build systems available were either ones I didn't like or weren't maintained anymore. Also because I'm mad.

## Build it from source

To build Beaver, you'll need to install the following dependencies.

* `glib-2.0`
* `json-glib-1.0`
* `valac`

Then, you can either build using `beaver`:

```
beaver build
```

or use `Valac`:

```
valac -o beaver --pkg json-glib-1.0 --pkg gio-2.0 --pkg posix src/main/vala/Beaver.vala src/main/vala/lib/*.vala src/main/vala/lib/cmd/*.vala src/main/vala/lib/cmd/arguments/*.vala src/main/vala/logging/*.vala src/main/vala/project/*.vala src/main/vala/parse/*.vala
```

## Why is it called Beaver?

Because beavers build dams, which look messy from the outside. This builds vala projects, and looks messy throughout!