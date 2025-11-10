String formatSummaryText(String summaryText) {
  return summaryText.replaceAll(r'\n', '\n').replaceAll(r'<br>', '\n');
}
