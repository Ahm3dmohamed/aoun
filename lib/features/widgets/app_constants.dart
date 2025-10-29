class AppConstants {
  static List<Map<String, dynamic>> campaigns = [
    {
      "image": "assets/img/room_bed.png",
      "title": "Providing medical equipment and supplies",
      "remaining": 250000,
      "donated": 200000,
    },
    {
      "image": "assets/img/atmida.png",
      "title": "Providing medical equipment and supplies",
      "remaining": 250000,
      "donated": 200000,
    },
    {
      "image": "assets/img/bed.png",
      "title": "Providing medical equipment and supplies",
      "remaining": 250000,
      "donated": 200000,
    },
    {
      "image": "assets/img/equipment.png",
      "title": "Providing medical equipment and supplies",
      "remaining": 250000,
      "donated": 200000,
    },
  ];

  static String selectedDonation = 'Preferred Donation';
  static String selectedLocation = 'Location';

  static List<String> donationOptions = [
    'Food',
    'Clothes',
    'Money',
    'Medical Supplies',
    'Books',
  ];

  static List<String> locations = [
    'Riyadh',
    'Jeddah',
    'Dammam',
    'Mecca',
    'Medina',
    'Tabuk',
    'Abha',
  ];
}
