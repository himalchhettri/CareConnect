import 'package:flutter/material.dart';
import 'app_data.dart';
import 'app_theme.dart';
import 'book_appointment_page.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;
  const DoctorDetailsPage({super.key, required this.doctor});

  Widget _metric(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
        child: Column(children: [
          Icon(icon, color: AppTheme.primary, size: 21),
          const SizedBox(height: 7),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 110),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(26)),
                  child: const Icon(Icons.person_rounded, size: 52, color: AppTheme.primary),
                ),
                const SizedBox(height: 15),
                Text(doctor.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(doctor.speciality, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 4),
                  Text('${doctor.rating}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(width: 7),
                  const Text('• Verified provider', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          Row(children: [
            _metric(Icons.workspace_premium_outlined, '${doctor.experienceYears}+ yrs', 'Experience'),
            const SizedBox(width: 10),
            _metric(Icons.groups_outlined, doctor.patients, 'Patients'),
            const SizedBox(width: 10),
            _metric(Icons.payments_outlined, '\$${doctor.fee.toStringAsFixed(0)}', 'Fee'),
          ]),
          const SizedBox(height: 22),
          const Text('About', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 9),
          Text(doctor.about, style: const TextStyle(color: AppTheme.textSecondary, height: 1.55, fontSize: 13)),
          const SizedBox(height: 22),
          const Text('Clinic location', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(13)),
                child: const Icon(Icons.location_on_outlined, color: AppTheme.primary),
              ),
              title: Text(doctor.location, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              subtitle: const Padding(padding: EdgeInsets.only(top: 4), child: Text('In-person consultation', style: TextStyle(fontSize: 11))),
            ),
          ),
          const SizedBox(height: 22),
          const Text('Availability', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFA7F3D0))),
            child: const Row(children: [
              Icon(Icons.check_circle_outline_rounded, color: Color(0xFF059669)),
              SizedBox(width: 10),
              Expanded(child: Text('Appointments available today and over the next 12 months.', style: TextStyle(fontSize: 12, color: Color(0xFF065F46), fontWeight: FontWeight.w600))),
            ]),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookAppointmentPage(doctor: doctor))),
            icon: const Icon(Icons.calendar_month_rounded),
            label: Text('Book Appointment • \$${doctor.fee.toStringAsFixed(0)}'),
          ),
        ),
      ),
    );
  }
}
