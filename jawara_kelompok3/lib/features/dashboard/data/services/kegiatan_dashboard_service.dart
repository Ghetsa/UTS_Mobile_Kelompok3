import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kegiatan_dashboard_model.dart';


class KegiatanDashboardService {
  Future<KegiatanDashboardModel> getDashboardSummary() async {
    return KegiatanDashboardModel(
      totalKegiatan: 1,
      kegiatanLewat: 1,
      kegiatanHariIni: 0,
      kegiatanAkanDatang: 0,
    );
  }
}
