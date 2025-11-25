import 'package:centranews/models/article_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/custom_theme.dart';
import '../providers/theme_provider.dart';
import 'article_container.dart';

class ArticleList extends ConsumerWidget {
  const ArticleList({
    super.key,
    required this.refreshIndicatorKey,
    required this.onRefreshCallback,
    required this.pageGridDelegate,
    required this.scrollController,
    required this.articleList,
    required this.shouldShowCircularProgressBar,
    required this.isLoading,
  });

  final Key refreshIndicatorKey;

  final Function onRefreshCallback;
  final SliverGridDelegateWithMaxCrossAxisExtent pageGridDelegate;
  final ScrollController scrollController;
  final List<ArticleData> articleList;
  final Function shouldShowCircularProgressBar;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              backgroundColor: currentTheme.currentColorScheme.bgPrimary,
              color: currentTheme.currentColorScheme.bgInverse,
              onRefresh: () async {
                onRefreshCallback();
              },

              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200),
                child: GridView.builder(
                  gridDelegate: pageGridDelegate,
                  controller: scrollController,
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  itemCount: articleList.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    try {
                      if (index == articleList.length) {
                        if (shouldShowCircularProgressBar()) {
                          return displayCircularProgressBar(currentTheme);
                        }
                      }
                      return ArticleContainer(
                        articleData: articleList[index],
                        key: ValueKey(articleList[index].articleID),
                      );
                    } catch (e) {
                      return displayCircularProgressBar(currentTheme);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayCircularProgressBar(CustomTheme currentTheme) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        color: currentTheme.currentColorScheme.bgInverse,
      ),
    );
  }
}
