import 'package:flutter/material.dart';
import 'package:yoga_customer/data/vos/yoga_course_vo.dart';

class CourseDetailsPage extends StatelessWidget {
  final YogaCourseVO course;

  const CourseDetailsPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.typeOfClass),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/yoga_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),

            // Course Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          course.typeOfClass,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '\$${course.pricePerClass.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    course.description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Course Information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip(Icons.schedule, course.duration),
                      _buildInfoChip(Icons.group, '${course.capacity} Students'),
                      _buildInfoChip(Icons.sports, course.difficultyLevel),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Classes Header
                  const Text(
                    'Upcoming Classes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Classes List
                  ...course.classes.map((yogaClass) => _buildClassCard(yogaClass)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Info Chip
  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 20),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  // Helper Widget: Class Card
  Widget _buildClassCard(YogaClass yogaClass) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${yogaClass.date}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Teachers: ${yogaClass.teacherNames}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Comment: ${yogaClass.comment}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
