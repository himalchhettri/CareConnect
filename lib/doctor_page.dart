import 'package:flutter/material.dart';
import 'app_data.dart';
import 'app_theme.dart';
import 'doctor_details_page.dart';

class FindDoctorPage extends StatefulWidget {
  const FindDoctorPage({super.key});

  @override
  State<FindDoctorPage> createState() => _FindDoctorPageState();
}

class _FindDoctorPageState extends State<FindDoctorPage> {
  String query = '';
  String selectedSpeciality = 'All';

  final List<String> specialities = ['All', 'GP', 'Dental', 'Skin'];

  List<Doctor> get filteredDoctors {
    return AppData.doctors.where((doctor) {
      final q = query.trim().toLowerCase();
      final matchesText = q.isEmpty || doctor.name.toLowerCase().contains(q) || doctor.speciality.toLowerCase().contains(q) || doctor.location.toLowerCase().contains(q);
      final matchesSpeciality = selectedSpeciality == 'All' ||
          (selectedSpeciality == 'GP' && doctor.speciality == 'General Practitioner') ||
          (selectedSpeciality == 'Dental' && doctor.speciality == 'Dentist') ||
          (selectedSpeciality == 'Skin' && doctor.speciality == 'Dermatologist');
      return matchesText && matchesSpeciality;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final doctors = filteredDoctors;
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Doctor')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
            child: TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: const InputDecoration(
                hintText: 'Search doctor, speciality or location',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              scrollDirection: Axis.horizontal,
              itemCount: specialities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final item = specialities[index];
                return ChoiceChip(
                  label: Text(item),
                  selected: selectedSpeciality == item,
                  onSelected: (_) => setState(() => selectedSpeciality = item),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: Row(children: [
              Text('${doctors.length} doctors available', style: const TextStyle(fontWeight: FontWeight.w800)),
              const Spacer(),
              const Icon(Icons.verified_rounded, size: 18, color: AppTheme.accent),
              const SizedBox(width: 5),
              const Text('Verified', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            ]),
          ),
          Expanded(
            child: doctors.isEmpty
                ? const Center(child: Text('No doctors match your search.', style: TextStyle(color: AppTheme.textSecondary)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    itemCount: doctors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailsPage(doctor: doctor))),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(17)),
                                child: const Icon(Icons.person_rounded, color: AppTheme.primary, size: 31),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    Expanded(child: Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                                    const Icon(Icons.star_rounded, size: 17, color: Color(0xFFF59E0B)),
                                    const SizedBox(width: 3),
                                    Text('${doctor.rating}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                  ]),
                                  const SizedBox(height: 4),
                                  Text(doctor.speciality, style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 9),
                                  Row(children: [
                                    const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.textSecondary),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text(doctor.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))),
                                  ]),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(99)),
                                      child: const Text('Available today', style: TextStyle(color: Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.w800)),
                                    ),
                                    const Spacer(),
                                    Text('\$${doctor.fee.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                                  ]),
                                ]),
                              ),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
