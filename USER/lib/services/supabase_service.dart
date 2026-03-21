import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SupabaseService {
  // 🔴 Get blood inventory
  static Future<Map<String, int>> getBloodInventory() async {
    final data = await supabase.from('blood_units').select();

    Map<String, int> result = {"RBC": 0, "Plasma": 0, "Platelets": 0};

    for (var item in data) {
      final component = item['component'];
      final qty = (item['quantity'] ?? 0) as num;

      if (result.containsKey(component)) {
        result[component] = result[component]! + qty.toInt();
      }
    }

    return result;
  }

  // 🏥 Get nearby blood banks count
  static Future<int> getBloodBankCount() async {
    final data = await supabase.from('blood_banks').select();

    return data.length;
  }

  // 🚚 Get latest order
  static Future<Map<String, dynamic>?> getLatestOrder() async {
    final data = await supabase
        .from('orders')
        .select()
        .order('created_at', ascending: false)
        .limit(1);

    if (data.isEmpty) return null;

    return data.first;
  }
}
