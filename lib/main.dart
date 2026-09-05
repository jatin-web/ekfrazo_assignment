import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ekfrazo_assignment/features/form/data/datasources/form_local_data_source.dart';
import 'package:ekfrazo_assignment/features/form/data/repositories/form_repository_impl.dart';
import 'package:ekfrazo_assignment/features/form/presentation/bloc/flow_bloc.dart';
import 'package:ekfrazo_assignment/features/form/presentation/bloc/flow_event.dart';
import 'package:ekfrazo_assignment/features/form/presentation/pages/flow_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Reports',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: BlocProvider(
        create: (_) => FlowBloc(
          repository: FormRepositoryImpl(
            localDataSource: FormLocalDataSourceImpl(),
          ),
        )..add(const FlowStarted()),
        child: const FlowPage(),
      ),
    );
  }
}
