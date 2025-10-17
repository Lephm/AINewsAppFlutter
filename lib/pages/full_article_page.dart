import 'package:centranews/models/article_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/theme_provider.dart';

final supabase = Supabase.instance.client;

class FullArticlePage extends ConsumerStatefulWidget {
  const FullArticlePage({super.key, this.arg});

  final String? arg;

  @override
  ConsumerState<FullArticlePage> createState() => _FullArticlePageState();
}

class _FullArticlePageState extends ConsumerState<FullArticlePage> {
  String articleID = "";
  bool _isLoading = true;
  ArticleData? articleData;

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    if (_isLoading == true) {
      fetchArticle();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        body: _isLoading
            ? displayCircularProgressBar()
            : ((articleData == null) ? renderErrorPage() : renderArticle()),
      ),
    );
  }

  Widget renderErrorPage() {
    return Placeholder();
  }

  Widget renderArticle() {
    var currentTheme = ref.watch(themeProvider);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Text(
              articleData!.articleContent,
              style: currentTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget displayCircularProgressBar() {
    var currentTheme = ref.watch(themeProvider);
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        color: currentTheme.currentColorScheme.bgInverse,
      ),
    );
  }

  Future<void> fetchArticle() async {
    try {
      final arg = widget.arg;
      articleID = arg as String;
      final data = await supabase
          .from("articles")
          .select()
          .eq("article_id", articleID)
          .single();
      setState(() {
        articleData = ArticleData.fromJson(data);
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showErrorMessage() {}
}
