import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/unregistered_list_view.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/wating_list_view.dart';
import 'package:ortho_waiting_list/router/app_router.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          tabs: const [
            Tab(
              text: 'الانتظار',
            ),
            Tab(
              text: 'العمليات',
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).goNamed(AppRouter.settings);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          UnregisteredListView(),
          WatingListView(),
        ],
      ),
    );
  }
}
