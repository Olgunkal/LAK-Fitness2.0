class NotifyParentProps {
  Function? onNotify;

  NotifyParentProps({this.onNotify});
}

class NotifyParentPropsWithParam<T> {
  void Function(T)? onNotify;

  NotifyParentPropsWithParam({this.onNotify});
}
