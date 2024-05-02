# Dashmon

A minimalistic CLI tool to run Flutter applications and auto hot reload it when files are changed. It will watch changes your application code and trigger a hot reload everytime a change happens.

## Install

```
$ flutter pub global activate dashmon
```

## Running

To run dashmon, just change the `flutter run` command to `dashmon`:

```
$ dashmon
```

All arguments passed to it will be proxied to the `flutter run` command, so if you want to run on a specific device, the following command can be used:

```
$ dashmon -d emulator-5555
```

You can also use attach command to attach to existing running Flutter instance:

```
dashmon attach
```

All arguments are passed like with `run` command


## FVM support

Dashmon supports [fvm](https://github.com/leoafarias/fvm) out of the box. Assuming that you have `fvm` installed on your computer, to run dashmon using fvm under the hood, just pass `--fvm` to it:

```
$ dashmon --fvm
```

Suggestions and feedback are welcomed!
