# Masterloop Core

## How to build

### Prerequisites

- [Dart SDK](https://www.dartlang.org/)

## Feedback

File bugs on [Masterloop Home](https://github.com/orgs/Masterloop/projects/1).

## License

Unless explicitly stated otherwise all files in this repository are licensed under the License in the root repository.

## Types

### Contents:

- [Template](#template)
- [Device](#device)
- [Observation](#observation)
- [Command](#command)
- [Argument](#argument)
- [DataType](#datatype)
- [Value](#value)

### [Template](./lib/src/models/template.dart)

###### optional:

- description
- observations
- commands

```
Template({
    String tid,
    String name,
    String description,
    String revision,
    String observations,
    String commands,
})
```

### [Device](./lib/src/models/device.dart)

###### optional:

- createdOn
- updatedOn
- latestPulse
- tid
- description
- template
- preSharedKey
- httpAuthenticationKey

```
Device({
    DateTime createdOn,
    DateTime updatedOn,
    DateTime latestPulse,
    String tid,
    String mid,
    String name,
    String description,
    Template template,
    String preSharedKey,
    String httpAuthenticationKey,
})
```

### [Observation](./lib/src/models/observation.dart)

###### optional:

- description

```
Observation({
    int id,
    String name,
    String description,
    DataType dataType,
})
```

### [Command](./lib/src/models/command.dart)

###### optional:

- description
- arguments

```
Command({
    int id,
    String name,
    String description,
    Iterable<Argument> arguments,
})
```

### [Argument](./lib/src/models/argument.dart)

```
Argument({
    int id,
    String name,
    DataType dataType,
})
```

### [DataType](./lib/src/models/data_type.dart)

###### enum

```
unknown, binary, boolean, double, integer, position, string
```

### [Value](./lib/src/models/value.dart)

###### optional:

- value
- timestamp

```
Value<T>({
    T value,
    DateTime timestamp,
})
```

#### ObservationValue

ObservationValue extends Value implements LiveValue

###### optional:

- value
- timestamp

```
ObservationValue({
    int id,
    dynamic value,
    DateTime timestamp,
})
```

#### ObservationValue

CommandValue extends Value implements LiveValue

###### optional:

- deliveredAt
- timestamp
- expiresAt
- wasAccepted
- arguments

```
CommandValue({
    int id,
    DateTIme deliveredAt,
    DateTIme timestamp,
    DateTime expiresAt,
    bool wasAccepted,
    Map<int, dynamic> arguments,
})
```
