import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoga_customer/bloc/yoga_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _showSuccessAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Lottie.asset(
          'assets/success.json',
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(composition.duration, () {
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
              }
            });
          },
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, String email, Function onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Your Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.email_outlined,
              size: 50,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Your email: $email',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              'Do you want to confirm your booking?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close confirm dialog
              onConfirm(); // Execute the confirmation logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final yogaProvider = Provider.of<YogaProvider>(context);
    final TextEditingController emailController = TextEditingController();

    void submitBooking(BuildContext context, YogaProvider yogaProvider, String email) async {
      _showLoadingDialog(context); // Show the loading dialog
      try {
        await yogaProvider.submitBooking(email); // Process the booking
        if (context.mounted) {
          Navigator.of(context).pop(); // Dismiss the loading dialog
          _showSuccessAnimation(context); // Show success animation
        }
      } catch (error) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Dismiss the loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking failed. Please try again.')),
          );
        }
      }
    }

    void showEmailDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Enter Your Email'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  Navigator.of(ctx).pop(); // Close the email dialog
                  _showConfirmDialog(
                    context,
                    email,
                    () => submitBooking(context, yogaProvider, email), // Confirmation logic
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your email')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      );
    }

    final isCartEmpty = yogaProvider.cart.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      floatingActionButton: isCartEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: showEmailDialog,
              child: const Icon(
                Icons.upload_file_rounded,
                color: Colors.white,
              ),
            ),
      body: isCartEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/empty_cart.json', // Use a Lottie animation for an empty cart
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: yogaProvider.cart.length,
                    itemBuilder: (ctx, index) {
                      final yogaClass = yogaProvider.cart[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon or Placeholder for Class
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue.withOpacity(0.1),
                                  ),
                                  child: const Icon(
                                    Icons.sports_gymnastics,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Class Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        yogaClass.typeOfClass,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${yogaClass.dayOfWeek} at ${yogaClass.time}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        yogaClass.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),

                                // Remove Button
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () => yogaProvider.removeFromCart(yogaClass),
                                ),
                              ],
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
