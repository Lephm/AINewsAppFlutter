import 'package:centranews/utils/article_data_retrieve_helper.dart';
import 'package:centranews/utils/pagination.dart';
import 'package:centranews/widgets/article_list.dart';
import 'package:centranews/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/article_data.dart';
import '../providers/localization_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_safe_area.dart';

final supabase = Supabase.instance.client;

class SearchedArticlesPage extends ConsumerStatefulWidget {
  const SearchedArticlesPage({super.key});

  @override
  ConsumerState<SearchedArticlesPage> createState() =>
      _SearchedArticlesPageState();
}

class _SearchedArticlesPageState extends ConsumerState<SearchedArticlesPage>
    with Pagination {
  final ScrollController scrollController = ScrollController();
  String searchTerm = "";
  List<ArticleData> searchedArticles = [];
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);

    scrollController.addListener(onScroll);

    return CustomSafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: currentTheme.currentColorScheme.bgPrimary,
          forceMaterialTransparency: true,
          leading: BackButton(
            color: currentTheme.currentColorScheme.bgInverse,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Center(
            child: CustomSearchBar(
              onSubmittedSearched: (value) {
                setState(() {
                  searchTerm = value;
                  resetCurrentPage();
                });
                searchArticles(value);
              },
            ),
          ),
        ),
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        body: (searchTerm == "" && searchedArticles.isEmpty)
            ? displayPleaseEnterSearchTerm()
            : cantFindRelatedArticles()
            ? displayCantFindRelevantArticles()
            : ArticleList(
                refreshIndicatorKey: refreshIndicatorKey,
                onRefreshCallback: () {},
                pageGridDelegate: pageGridDelegate,
                scrollController: scrollController,
                articleList: searchedArticles,
                shouldShowCircularProgressBar: () =>
                    searchedArticles.isEmpty && isLoading,
                isLoading: isLoading,
              ),
      ),
    );
  }

  bool cantFindRelatedArticles() {
    return (searchedArticles.isEmpty && !isLoading);
  }

  Widget displayPleaseEnterSearchTerm() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        localization.pleaseEnterSearchTerm,
        style: currentTheme.textTheme.bodyMediumBold,
      ),
    );
  }

  void searchArticles(String value) async {
    if (value == "" || value.isEmpty) return;
    setState(() {
      searchedArticles = [];
      isLoading = true;
    });
    try {
      var data = await supabase
          .from("articles")
          .select()
          .or("title.ilike.%$value%,summary.ilike.%$value%")
          .range(startIndex, endIndex)
          .order('created_at', ascending: false)
          .order('article_id', ascending: true);

      if (data.isNotEmpty) {
        for (var value in data) {
          if (context.mounted) {
            setState(() {
              searchedArticles = [
                ...searchedArticles,
                ArticleData.fromJson(value),
              ];
            });
          }
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

  void onScroll() async {
    if (isTheEndOfThePage(scrollController)) {
      try {
        if (mounted) {
          setState(() {
            increaseCurrentPage();
          });
        }

        await fetchMoreSearchedArticles();
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

  Future<void> fetchMoreSearchedArticles() async {
    if (searchTerm == "" || searchTerm.isEmpty) return;
    setState(() {
      isLoading = true;
    });
    try {
      var data = await supabase
          .from("articles")
          .select()
          .or("title.ilike.%$searchTerm%,summary.ilike.%$searchTerm%")
          .range(startIndex, endIndex)
          .order('created_at', ascending: false)
          .order("article_id", ascending: true);
      List<ArticleData> newSearchedData = [];
      if (data.isNotEmpty) {
        for (var value in data) {
          newSearchedData = [...newSearchedData, ArticleData.fromJson(value)];
        }
      }
      if (mounted) {
        setState(() {
          searchedArticles = getUniqueArticleDatas(
            searchedArticles,
            newSearchedData,
          );
        });
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
