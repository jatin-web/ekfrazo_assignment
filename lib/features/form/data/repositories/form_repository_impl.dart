import 'package:ekfrazo_assignment/features/form/data/datasources/form_local_data_source.dart';
import 'package:ekfrazo_assignment/features/form/data/models/flow_config_model.dart';
import 'package:ekfrazo_assignment/features/form/domain/entities/flow_config.dart';
import 'package:ekfrazo_assignment/features/form/domain/repositories/form_repository.dart';

class FormRepositoryImpl implements FormRepository {
  final FormLocalDataSource localDataSource;
  const FormRepositoryImpl({required this.localDataSource});

  @override
  Future<FlowConfig> loadFlowConfig() async {
    final flowConfigJson = await localDataSource.getFlowConfigJson();
    return FlowConfigModel.fromJson(flowConfigJson);
  }
}
