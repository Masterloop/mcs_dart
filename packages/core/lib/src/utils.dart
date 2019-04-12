DateTime toDateTime(String date) {
  if (date == null) {
    return null;
  }

  if (date.length >= 28) {
    date = date.substring(0, 26) + "Z";
  }

  return DateTime.parse(date);
}
