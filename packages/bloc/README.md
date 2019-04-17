# Masterloop Bloc

## How to build

### Prerequisites

-Dart SDK

## Feedback

File bugs on [Masterloop Home](https://github.com/orgs/Masterloop/projects/1).

## License

Unless explicitly stated otherwise all files in this repository are licensed under the License in the root repository.

## Using the Masterloop Bloc

Implemeted types:
-TemplatesBloc
-DeviceBloc
-DevicesBloc
-CommandsBloc
-ObservationsBloc

## API:

### TemplatesBloc, DevicesBloc\*

```
TemplatesBloc({
    //Called on templatesBloc.Refresh() and returns most updated list of templates
    Future<Iterable<Template>> onRefresh,
    //Comparator to use when sorting the templates
    Comparator<Template> comparator,
  })
```

#### Methods

refreshing

```
Future<void> refresh()
```

sorting

```
void sort(Comparator<Template> comparator)
```

filtering

```
  void filter(Test<Template> tester)
```

##### \*for Devices Bloc use type DevicesBloc and Device types
