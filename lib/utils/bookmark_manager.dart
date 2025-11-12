import 'dart:math' as math;

import 'package:centranews/models/article_data.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'article_data_retrieve_helper.dart';

final supabase = Supabase.instance.client;

class BookmarkManager {
  static Future<bool> isArticleBookmarked(String articleId) async {
    if (supabase.auth.currentUser == null) {
      return false;
    }
    try {
      var data = await supabase
          .from('bookmarks')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('article_id', articleId);
      return data.isEmpty ? false : true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<void> addArticleIdToBookmark(
    String userId,
    String articleId,
    int currentBookmarkCount,
  ) async {
    try {
      await increaseBookmarkCount(currentBookmarkCount, articleId);
      await supabase.from('bookmarks').insert({
        'user_id': userId,
        'article_id': articleId,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> removeArticleIdFromBookmark(
    String userId,
    String articleId,
    int currentBookmarkCount,
  ) async {
    try {
      await decreaseBookmarkCount(currentBookmarkCount, articleId);
      await supabase
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('article_id', articleId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<ArticleData>> getBookmarkArticles(
    int startIndex,
    int endIndex,
  ) async {
    if (supabase.auth.currentUser == null) {
      return [];
    }
    List<String> articleIdList = [];
    var articleIdDatas = await supabase
        .from('bookmarks')
        .select()
        .eq("user_id", supabase.auth.currentUser!.id)
        .range(startIndex, endIndex);
    for (var articleIdData in articleIdDatas) {
      if (articleIdData["article_id"] != null) {
        articleIdList.add(articleIdData["article_id"]);
      }
    }
    var data = await supabase
        .from('articles')
        .select(ARTICLESSELECTPARAMETER)
        .inFilter("article_id", articleIdList)
        .order('created_at', ascending: false)
        .order('article_id', ascending: true);
    List<ArticleData> bookmarkArticles = [];
    for (var article in data) {
      bookmarkArticles.add(ArticleData.fromJson(article));
    }
    return bookmarkArticles;
  }

  static Future<int> getBookmarkCount(String articleId) async {
    try {
      final List<Map<String, dynamic>> data = await supabase
          .from('articles_additional_data')
          .select('bookmark_count')
          .eq("article_id", articleId);
      int bookmarkCount = data.isEmpty ? 0 : data[0]["bookmark_count"];
      return bookmarkCount;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  static Future<void> increaseBookmarkCount(
    int currentBookmarkCount,
    String articleId,
  ) async {
    await supabase
        .from('articles_additional_data')
        .upsert({
          'article_id': articleId,
          'bookmark_count': currentBookmarkCount += 1,
        })
        .eq("article_id", articleId);
  }

  static Future<void> decreaseBookmarkCount(
    int currentBookmarkCount,
    String articleId,
  ) async {
    await supabase
        .from('articles_additional_data')
        .upsert({
          'article_id': articleId,
          'bookmark_count': math.max(0, currentBookmarkCount -= 1),
        })
        .eq("article_id", articleId);
  }
}
