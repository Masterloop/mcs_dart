# Masterloop FLutter Bloc

## How to build

### Prerequisites

-Flutter SDK

## Feedback

File bugs on [Masterloop Home](https://github.com/orgs/Masterloop/projects/1).

## License

Unless explicitly stated otherwise all files in this repository are licensed under the License in the root repository.

## Using the Masterloop Flutter Bloc

-Bloc Type

```
BlocProvider(
    bloc: someBloc,
    child: someChild
)
```

later in code get the bloc from the subtree:

```
final someBloc = BlocProvider.of<SomeBlocType>(context);
```

-Api Type

```
ApiProvider(
    api: someApi,
    child: someChild
)
```

later in code get the api from the subtree:

```
final someApi = ApiProvider.of<SomeApiType>(context);
```

-Generic Type

```
Provider<T>(
    data: someData,
    child: someChild
)
```

later in code get the data from the subtree:

```
final someBloc = Provider.of<T>(context);
```

limitations:
-you cant have 2 providers of some type in the same subtree
