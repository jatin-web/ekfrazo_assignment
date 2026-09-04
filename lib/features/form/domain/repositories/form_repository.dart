import 'package:ekfrazo_assignment/features/form/domain/entities/flow_config.dart';

abstract interface class FormRepository {
  Future<FlowConfig> loadFlowConfig();
}
