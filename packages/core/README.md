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

### Template

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

### Device

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
