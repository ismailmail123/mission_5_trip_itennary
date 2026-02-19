import 'package:sizer/sizer.dart';

class AppSpacing {
  // 💎 Penggunaan `Sizer` untuk mengatur unit spasi adalah keputusan yang 
  // sangat brilian untuk memastikan responsivitas layar di berbagai device! 📏🔋
  const AppSpacing._();

  static double get xs => 1.w;   // ~4
  static double get sm => 2.w;   // ~8
  static double get md => 4.w;   // ~16
  static double get lg => 6.w;   // ~24
  static double get xl => 8.w;   // ~32
}
