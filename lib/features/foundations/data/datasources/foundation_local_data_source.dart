import 'package:aoun/features/foundations/data/models/donation_model.dart';
import 'package:aoun/features/foundations/data/models/foundation_model.dart';
import 'package:hive/hive.dart';

abstract class FoundationLocalDataSource {
  Future<void> saveFoundation(FoundationModel foundation);
  Future<List<FoundationModel>> getFoundations();
  Future<void> saveDonation(DonationModel donation);
  Future<List<DonationModel>> getDonations();
  Future<void> updateFoundationDonations(String foundationId, double amount);
}

class FoundationLocalDataSourceImpl implements FoundationLocalDataSource {
  static const String _foundationsBoxName = 'foundationsBox';
  static const String _donationsBoxName = 'donationsBox';

  Box<FoundationModel> get _foundationsBox =>
      Hive.box<FoundationModel>(_foundationsBoxName);
  Box<DonationModel> get _donationsBox =>
      Hive.box<DonationModel>(_donationsBoxName);

  @override
  Future<void> saveFoundation(FoundationModel foundation) async {
    await _foundationsBox.put(foundation.id, foundation);
  }

  @override
  Future<List<FoundationModel>> getFoundations() async {
    final list = _foundationsBox.values.toList();
    if (list.isEmpty) {
      // Seed default foundations for demonstration / donor flow
      final seedFoundations = [
        const FoundationModel(
          id: '101',
          name: '57357 Children Cancer Hospital',
          email: 'info@57357.org',
          phone: '19057',
          foundationType: 'medical',
          donationType: 'Cancer Treatment',
          location: 'Cairo',
          createdAt: '2025-01-20',
          totalDonations: 1450000.0,
          targetAmount: 2000000.0,
          imageUrl:
              'https://res.cloudinary.com/dqn5b2f5h/image/upload/v1763526772/donation/b7p7a5yq70z7c1fgh0g2.jpg',
          description:
              'Specialized pediatric cancer treatment and research center in Cairo, Egypt.',
        ),
        const FoundationModel(
          id: '102',
          name: 'Magdi Yacoub Heart Foundation',
          email: 'info@myf-egypt.org',
          phone: '19731',
          foundationType: 'medical',
          donationType: 'Heart Surgery',
          location: 'Aswan',
          createdAt: '2025-02-12',
          totalDonations: 1000000.0,
          targetAmount: 1500000.0,
          description:
              'Advanced cardiac treatment and heart surgery services, providing free care.',
        ),
        const FoundationModel(
          id: '1',
          name: 'Resala Charity Organization',
          email: 'contact@resala.org',
          phone: '19050',
          foundationType: 'charity',
          donationType: 'Community Services',
          location: 'Cairo',
          createdAt: '2025-01-15',
          totalDonations: 320000.0,
          targetAmount: 500000.0,
          description:
              'Supporting education, healthcare, food assistance, and orphan care.',
        ),
        const FoundationModel(
          id: '2',
          name: 'Misr El Kheir Foundation',
          email: 'info@mek.eg',
          phone: '16140',
          foundationType: 'charity',
          donationType: 'Education Support',
          location: 'Cairo',
          createdAt: '2025-02-10',
          totalDonations: 650000.0,
          targetAmount: 1000000.0,
          description:
              'Community development projects, healthcare initiatives, and educational support.',
        ),
        const FoundationModel(
          id: '4',
          name: 'Baheya Foundation',
          email: 'info@baheya.org',
          phone: '16602',
          foundationType: 'medical',
          donationType: 'Breast Cancer Detection',
          location: 'Giza',
          createdAt: '2025-04-05',
          totalDonations: 900000.0,
          targetAmount: 1200000.0,
          imageUrl:
              'https://res.cloudinary.com/dqn5b2f5h/image/upload/v1763526772/donation/b7p7a5yq70z7c1fgh0g2.jpg',
          description:
              'Free breast cancer treatment and awareness programs for women.',
        ),
      ];

      for (final f in seedFoundations) {
        await _foundationsBox.put(f.id, f);
      }
      return seedFoundations;
    }
    return list;
  }

  @override
  Future<void> saveDonation(DonationModel donation) async {
    await _donationsBox.put(donation.id, donation);
  }

  @override
  Future<List<DonationModel>> getDonations() async {
    return _donationsBox.values.toList();
  }

  @override
  Future<void> updateFoundationDonations(
    String foundationId,
    double amount,
  ) async {
    final foundation = _foundationsBox.get(foundationId);
    if (foundation != null) {
      final updated = FoundationModel(
        id: foundation.id,
        name: foundation.name,
        email: foundation.email,
        phone: foundation.phone,
        foundationType: foundation.foundationType,
        donationType: foundation.donationType,
        location: foundation.location,
        createdAt: foundation.createdAt,
        totalDonations: foundation.totalDonations + amount,
        imageUrl: foundation.imageUrl,
        description: foundation.description,
        targetAmount: foundation.targetAmount,
      );
      await _foundationsBox.put(foundationId, updated);
    }
  }
}
