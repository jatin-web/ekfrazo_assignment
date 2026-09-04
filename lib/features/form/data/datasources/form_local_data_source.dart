import 'package:ekfrazo_assignment/db/flow_config_json.dart';

abstract class FormLocalDataSource {
  Future<Map<String, dynamic>> getFlowConfigJson();
}

class FormLocalDataSourceImpl implements FormLocalDataSource {
  @override
  Future<Map<String, dynamic>> getFlowConfigJson() async {
    await Future.delayed(Duration(seconds: 1));
    return flowConfigJson;
  }
}
