import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_customer/bloc/yoga_provider.dart';
import 'package:yoga_customer/pages/course_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedDayOfWeek;

  final List<String> _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  Widget build(BuildContext context) {
    final yogaProvider = Provider.of<YogaProvider>(context);

    final filteredClasses = yogaProvider.classes.where((yogaClass) {
      final matchesSearchQuery = yogaClass.typeOfClass.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          yogaClass.time.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDayOfWeek = _selectedDayOfWeek == null || yogaClass.dayOfWeek.toLowerCase() == _selectedDayOfWeek?.toLowerCase();

      return matchesSearchQuery && matchesDayOfWeek;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Classes'),
      ),
      body: Column(
        children: [
          // Search by Class Type
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by Class Name',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // Dropdown for Day of the Week
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Filter by Day of the Week',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: _selectedDayOfWeek,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All Days'),
                ),
                ..._daysOfWeek.map(
                  (day) => DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDayOfWeek = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Display Filtered Classes
          Expanded(
            child: filteredClasses.isEmpty
                ? Center(
                    child: Text(
                      'No Yoga Classes Found',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredClasses.length,
                    itemBuilder: (ctx, index) {
                      final yogaClass = filteredClasses[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CourseDetailsPage(
                                course: yogaClass,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        yogaClass.typeOfClass.replaceAll("_", " "),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '\$${yogaClass.pricePerClass.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${yogaClass.dayOfWeek} at ${yogaClass.time}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    yogaClass.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        yogaProvider.addToCart(yogaClass);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Added to Cart'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
