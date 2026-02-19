// 💎 Penggunaan constants untuk data statis seperti kategori 
// dan destinasi populer adalah cara yang bagus untuk menjaga 
// kode tetap bersih dan mudah dikelola. Mantap! 🌍✨
class TripConstants {
  static const List<String> tripCategories = [
    'Cultural',
    'Adventure',
    'Beach',
    'Mountain',
    'City',
    'Historical',
    'Food',
    'Shopping',
  ];

  static const List<String> popularDestinations = [
    'Korea',
    'Delhi',
    'Hong Kong',
    'London',
    'Denmark',
    'Japan',
    'France',
    'Italy',
  ];

  static const List<Map<String, dynamic>> defaultHotels = [
    {
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      'name': 'Urban Hotel Kyoto',
      'price': '¥7,200',
      'rating': '4.5',
    },
    {
      'image': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      'name': 'Ryokan Inn',
      'price': '¥10,000',
      'rating': '4.7',
    },
  ];
}