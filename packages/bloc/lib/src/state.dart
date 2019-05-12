class BlocState<S> {
  final S data;
  final bool hasData;

  BlocState({
    this.data,
  }) : hasData = data == null;

  @override
  operator ==(other) =>
      other is BlocState<S> && hasData == other.hasData && data == other.data;

  @override
  int get hashCode => data.hashCode ^ hasData.hashCode;
}
