import 'package:mobx/mobx.dart';
import 'package:coletas_leite/src/models/licenca/licenca_model.dart';
import 'package:platform_device_id/platform_device_id.dart';

part 'get_info_phone_controller.g.dart';

class GetInfoPhoneController = _GetInfoPhoneControllerBase
    with _$GetInfoPhoneController;

abstract class _GetInfoPhoneControllerBase with Store {
  @observable
  LicencaModel licenca = LicencaModel();

  @action
  Future<void> getInfoPhone() async {
    final deviceId = await PlatformDeviceId.getDeviceId;
    final map = {'id': deviceId};

    licenca = LicencaModel.fromMap(map);
  }
}
