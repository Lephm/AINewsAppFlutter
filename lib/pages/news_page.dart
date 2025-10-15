import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/article_data.dart';

final supabase = Supabase.instance.client;

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> {
  @override
  Widget build(BuildContext context) {
    test();
    return Container(child: const Text("News"));
  }

  //TODO: Implement Articles Provider
  void test() async {
    final data = await supabase.from('articles').select().contains('', []);
    debugPrint(ArticleData.fromJson(data[0]).toString());
  }
}
