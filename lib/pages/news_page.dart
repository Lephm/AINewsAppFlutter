import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/main_articles_provider.dart';
import 'package:centranews/providers/query_categories_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/article_list.dart';

const numberOfArticlesBeforeShowingBannerAd = 1;

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> with Pagination {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController scrollController = ScrollController();
  bool hasFetchDataForTheFirstTime = false;
  bool isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    scrollController.addListener(onScroll);
    ref.listen(queryCategoriesProvider, (oldQueries, newQueries) {
      if (oldQueries != newQueries) {
        refreshDataToRefelectSearchQueries();
      }
    });
    if (mounted && !hasFetchDataForTheFirstTime) {
      fetchDataForFirstTime();
    }
    var queryCategories = ref.watch(queryCategoriesProvider);
    var mainArticles = ref.watch(mainArticlesProvider);
    return cantFindRelevantArticles()
        ? displayCantFindRelevantArticles()
        : (isRefreshing && !hasFetchDataForTheFirstTime)
        ? displayCircularProgressBar(currentTheme)
        : ArticleList(
            refreshIndicatorKey: refreshIndicatorKey,
            onRefreshCallback: refreshData,
            pageGridDelegate: pageGridDelegate,
            scrollController: scrollController,
            articleList: mainArticles,
            shouldShowCircularProgressBar: () =>
                queryCategories.isEmpty && isLoading,
            isLoading: isLoading,
          );
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool cantFindRelevantArticles() {
    var queryCategories = ref.watch(queryCategoriesProvider);
    var mainArticles = ref.watch(mainArticlesProvider);
    return mainArticles.isEmpty && !isLoading && queryCategories.isNotEmpty;
  }

  void refreshDataToRefelectSearchQueries() {
    debugPrint("query new articles");
    scrollToTop(scrollController);
    refreshData();
  }

  void onScroll() async {
    if (isTheEndOfThePage(scrollController)) {
      debugPrint("Fetch new articles");
      try {
        setState(() {
          increaseCurrentPage();
        });
        await fetchMoreArticlesList(context);
      } catch (e) {
        debugPrint(e.toString());
        setState(() {
          decreaseCurrentPage();
        });
      }
    }
  }

  Future<void> fetchMoreArticlesList(BuildContext context) async {
    if (currentPage == 0) return;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var mainArticleNotifier = ref.watch(mainArticlesProvider.notifier);
    var queryCategoriesList = ref.watch(queryCategoriesProvider);
    try {
      await mainArticleNotifier.fetchArticlesData(
        context: context,
        startIndex: startIndex,
        endIndex: endIndex,
        queryParams: queryCategoriesList,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void fetchDataForFirstTime() async {
    var mainArticleNotifier = ref.watch(mainArticlesProvider.notifier);
    setState(() {
      resetCurrentPage();
      hasFetchDataForTheFirstTime = false;
      isLoading = true;
      isRefreshing = true;
    });
    try {
      await mainArticleNotifier.refereshArticlesData(
        context: context,
        startIndex: startIndex,
        endIndex: endIndex,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          hasFetchDataForTheFirstTime = true;
          isLoading = false;
          isRefreshing = false;
        });
      }
    }
  }

  Widget displayCantFindRelevantArticles() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        localization.cantFindRelevantArticles,
        style: currentTheme.textTheme.bodyMediumBold,
      ),
    );
  }

  void refreshData() async {
    var mainArticleNotifier = ref.watch(mainArticlesProvider.notifier);
    var queryCategoriesList = ref.watch(queryCategoriesProvider);
    setState(() {
      resetCurrentPage();
      isLoading = true;
      isRefreshing = true;
    });
    debugPrint("refresh articles data");
    await mainArticleNotifier.refereshArticlesData(
      context: context,
      startIndex: startIndex,
      endIndex: endIndex,
      queryParams: queryCategoriesList,
    );
    if (mounted) {
      setState(() {
        isLoading = false;
        isRefreshing = false;
      });
    }
  }
}
