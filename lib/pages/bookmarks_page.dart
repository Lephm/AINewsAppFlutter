import 'package:centranews/models/article_data.dart';
import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/article_data_retrieve_helper.dart';
import 'package:centranews/utils/bookmark_manager.dart';
import 'package:centranews/widgets/article_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/pagination.dart';

final supabase = Supabase.instance.client;

class BookmarksPage extends ConsumerStatefulWidget {
  const BookmarksPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends ConsumerState<BookmarksPage> with Pagination {
  List<ArticleData> bookmarkArticles = [];
  final ScrollController scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var localUser = ref.watch(userProvider);
    scrollController.addListener(onScroll);
    if (localUser != null && !isLoading && bookmarkArticles.isEmpty) {
      return displayYouDoNotHaveAnyBookmarks();
    }
    return localUser == null
        ? notLoginPrompt()
        : ArticleList(
            refreshIndicatorKey: refreshIndicatorKey,
            onRefreshCallback: onRefresh,
            pageGridDelegate: pageGridDelegate,
            scrollController: scrollController,
            articleList: bookmarkArticles,
            shouldShowCircularProgressBar: () =>
                bookmarkArticles.isEmpty && isLoading,
            isLoading: isLoading,
          );
  }

  Widget notLoginPrompt() {
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          spacing: 10,
          children: [
            Text(
              localization.youMustSignInPrompt,
              style: currentTheme.textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/sign_in");
              },
              child: Text(
                localization.signIn,
                style: currentTheme.textTheme.bodyMediumBold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget displayYouDoNotHaveAnyBookmarks() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          localization.youDoNotHaveAnyBookmark,
          style: currentTheme.textTheme.bodyMediumBold,
        ),
      ),
    );
  }

  void onScroll() async {
    if (isTheEndOfThePage(scrollController)) {
      try {
        if (mounted) {
          setState(() {
            increaseCurrentPage();
          });
        }

        await fetchMoreBookmarkArticles(context);
      } catch (e) {
        debugPrint(e.toString());
        if (mounted) {
          setState(() {
            decreaseCurrentPage();
          });
        }
      }
    }
  }

  Future<void> fetchMoreBookmarkArticles(BuildContext context) async {
    var localUser = ref.watch(userProvider);
    if (localUser == null) {
      return;
    }
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var bookmarkArticlesList = await BookmarkManager.getBookmarkArticles(
        startIndex,
        endIndex,
      );
      if (bookmarkArticlesList.isNotEmpty) {
        if (mounted) {
          setState(() {
            bookmarkArticles = getUniqueArticleDatas(
              bookmarkArticlesList,
              bookmarkArticlesList,
            );
          });
        }
      }
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

  void onRefresh() async {
    if (mounted) {
      setState(() {
        resetCurrentPage();
        isLoading = true;
      });
    }

    try {
      var bookmarkArticlesList = await BookmarkManager.getBookmarkArticles(
        startIndex,
        endIndex,
      );
      if (mounted) {
        setState(() {
          bookmarkArticles = [];
        });
      }
      if (bookmarkArticlesList.isNotEmpty) {
        if (mounted) {
          setState(() {
            bookmarkArticles = [...bookmarkArticles, ...bookmarkArticlesList];
          });
        }
      }
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
}
