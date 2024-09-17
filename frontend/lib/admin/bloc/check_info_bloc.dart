import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/check_info_event.dart';
import 'package:frontend/admin/state/check_info_state.dart';

class AdminCheckInfoBloc extends Bloc<AdminCheckInfoEvent, AdminCheckInfoState> {
  AdminCheckInfoBloc() : super(AdminCheckInfoInitial()); //กำหนดสถานะเริ่มต้น

  Stream<AdminCheckInfoState> mapEventToState(AdminCheckInfoEvent event) async* {
    if (event is CheckAllUsersEvent) {
      yield CheckingAllUsersState();  //ตรวจสอบผู้ใช้ทั้งหมด

    } else if (event is CheckUsersByNameEvent) { //ตรวจสอบผู้ใช้ตามชื่อ
      yield CheckingUsersByNameState();

    } else if (event is CheckOwnersOfPetsEvent) { //ตรวจสอบเจ้าของสัตว์เลี้ยง
      yield CheckingOwnersOfPetsState();
      
    } else if (event is CheckVaccinesOfPetsEvent) { //ตรวจสอบวัคซีน
      yield CheckingVaccinesOfPetsState();
    }
  }
}
